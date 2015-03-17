# NOTE you might have to change parsing for varlists / let statements

require './scanner'
require './var_table'
require 'json'

$var_table = VarTable.new
$pop_count = 0
$pop_count_stack = []
$scope_stack = []

class SemanticException < Exception  
  def initialize operator, *args
    super "Error: Undefined behavior for '#{operator}' with arguments '#{args.join(', ')}'."
  end
end




# Representation of an N-ary tree
# Has a value (:val) which can be anything that supports the to_s method
# Has :children, which is a 0 to N length array off other N-ary trees.
class NaryTree
  attr_accessor :val, :children
  
  def initialize val, *children
    self.val = val
    self.children = children
  end
  
  
  
  
  # used for string concatenation
  def concat_send 
    # Send and recieve stuff from gforth
    gforth_string = children.rotate(1).map{|c| c.gforth_val('string') }.join(" ")
    `echo '#{gforth_string} type bye' > gforth.in`
    `gforth gforth.in > gforth.out`    
    MString.new('"' + Scanner.scan_file('gforth.out').map{|t|t.val}.join(' ') + '"')
  end
  
  
  
  # used for negation
  def negation_send type
    # Choose which stack to pop from
    case type
    when 'float'
      printer = 'fe.'
      neg = 'fnegate'
    when 'integer'
      printer = '.'
      neg = 'negate'
    end
    
    # Send and recieve stuff from gforth
    gforth_string = children[1..-1].map{|c| c.gforth_val(type) }.join(" ")
    `echo '#{gforth_string} #{neg} #{printer} bye' > gforth.in`
    `gforth gforth.in > gforth.out`
    result = Scanner.scan_file('gforth.out')

    #Deal with negative signs
    if result.first.class == Minus
      # Create a new value for the second token, who should have the correct type. While we
      # don't internally have a way to generate negatives, gforth should understand it just fine.
      result = result[1].class.new(result.map{|e|e.val}.join(''))
    else
      result = result.first
    end
    
    result
  end
  
  
  
  # This actually runs gforth crap and returns something
  def send type, logic=false
    # Choose which stack to pop from
    case type
    when 'float'
      printer = 'fe.'
    when 'integer'
      printer = '.'
    end
    if logic
      printer = '.'
    end
    
    # Send and recieve stuff from gforth
    gforth_string = children.rotate(1).map{|c| c.gforth_val(type) }.join(" ")
    `echo '#{gforth_string} #{printer} bye' > gforth.in`
    `gforth gforth.in > gforth.out`
    result = Scanner.scan_file('gforth.out')

    #Deal with negative signs
    if result.first.class == Minus
      # Create a new value for the second token, who should have the correct type. While we
      # don't internally have a way to generate negatives, gforth should understand it just fine.
      result = result[1].class.new(result.map{|e|e.val}.join(''))
    else
      result = result.first
    end

    # Add special stuff if our operator results in boolean result
    if logic
      if result.val == '-1'
        result = MBoolean.new('true')
      else
        result = MBoolean.new('false')
      end
    end
    
    result
  end
  
  
  
  
  # If it has a value, then convert that value to gforth.
  # If it doesn't have a value, then it's an expression and needs to be evaluated
  def eval
    return if self.children.empty?
    
    # Remove parenthesis
    if self.children.first.val.class == LeftParen
      self.children = self.children[1..-2]
    end
    
    return if self.children.empty?
    
    # Ensure all children have types, so we can evaluate with semantics
    # There are special cases for conditionals, where we delay evaluation.
    if [While, If].include?(self.children[0].val.class)
      # Use stupid serialization/deserialization because of GODAMN SHALLOW COPYING!!!!!!!!
      children_copy = Marshal.load(Marshal.dump(self.children))
      children[1].val = self.children[1].eval unless self.children[1].val
    else
      self.children.each do |child|
        child.val = child.eval unless child.val
      end
    end
    
    
    child_vals = self.children.map{|c|c.val}
    child_classes = child_vals.map{|c|c.class}
    first_child_val = child_vals[0]
    first_child_class = child_classes[0]
    last_child_vals = child_vals[1..-1]
    last_child_classes = child_classes[1..-1]
    
    
    # Go through and evaluate each child to ensure that IDs become something we can work with
    unless [Assign].include?(first_child_class)
      last_child_classes.each_with_index do |child, index|
        if child == Id
          var = last_child_vals[index].val
          type = $var_table.get_type(var)
          val = $var_table.get_val(var)
          last_child_vals[index] = val
          last_child_classes[index] = type
          self.children[index + 1].val = type.new(val)
        end
      end
    end
    
    
    
    case
    # TRIG
    when first_child_val.kind_of?(Trig)
      if last_child_classes != [MReal]
        throw SemanticException.new(first_child_val, last_child_vals)
      else
        return send 'float'
      end
    
    
    # LOGIC
    when first_child_val.kind_of?(Logic)
      if last_child_classes == [MReal, MInteger] || last_child_classes == [MReal, MReal] || last_child_classes == [MInteger, MReal]
        return send 'float', true
      elsif last_child_classes == [MInteger, MInteger]
        return send 'integer', true
      else
        throw SemanticException.new(first_child_val, last_child_vals)
      end
    
    
    # NEGATION / SUBTRACTION
    when first_child_class == Minus
      if last_child_classes == [MReal]
        return negation_send 'float'
      elsif last_child_classes == [MInteger]
        return negation_send 'integer'
      elsif last_child_classes == [MReal, MInteger] || last_child_classes == [MReal, MReal] || last_child_classes == [MInteger, MReal]
        return send 'float'
      elsif last_child_classes == [MInteger, MInteger]
        return send 'integer'
      else
        throw SemanticException.new(first_child_val, last_child_vals)
      end
    
    
    # All other number operators except addition
    when [Multiply, Divide, Modulo, Exponent].include?(first_child_class)
      if last_child_classes == [MReal, MInteger] || last_child_classes == [MReal, MReal] || last_child_classes == [MInteger, MReal]
        return send 'float'
      elsif last_child_classes == [MInteger, MInteger]
        return send 'integer'
      else
        throw SemanticException.new(first_child_val, last_child_vals)
      end
    
    
    # Addition / Concatenation
    when first_child_class == Plus
      if last_child_classes == [MReal, MInteger] || last_child_classes == [MReal, MReal] || last_child_classes == [MInteger, MReal]
        return send 'float'
      elsif last_child_classes == [MInteger, MInteger]
        return send 'integer'
      elsif last_child_classes == [MString, MString]
        return concat_send
      else
        throw SemanticException.new(first_child_val, last_child_vals)
      end
    
    
    # And / Or
    when [And, Or].include?(first_child_class)
      if last_child_classes == [MBoolean, MBoolean] 
        return send 'boolean', true
      else
        throw SemanticException.new(first_child_val, last_child_vals)
      end
    
    
    # Negation
    when first_child_class == Not
      if last_child_classes == [MBoolean] 
        return send 'boolean', true
      else
        throw SemanticException.new(first_child_val, last_child_vals)
      end
    
    
    # Variable ssignment
    when first_child_class == Assign
      if last_child_classes[0] == Id        
        var = last_child_vals[0].val
        $var_table.assign(var, last_child_vals[1])
        return 'assignment'
      else
        throw SemanticException.new(first_child_val, last_child_vals)
      end
    
    
    
    # Let statement
    # Records pop count for current level. Resets pop count. Leaves flag to free variables.
    when first_child_class == Let
      if last_child_vals == ['varlist']
        $pop_count_stack << $pop_count
        $pop_count = 0
        return 'free_variables'
      else
        throw SemanticException.new(first_child_val, last_child_vals)
      end
    
    
    # Declare variables.
    # Need to track the variable for when we free it later.
    when first_child_class == Id
      if last_child_classes == [Type]
        $var_table.declare(first_child_val.val, last_child_vals[0].val)
        $scope_stack.push(first_child_val.val)
        $pop_count += 1
        return 'declaration'
      else
        throw SemanticException.new(first_child_val, last_child_vals)
      end
    
    
    # Varlists
    when first_child_val == 'declaration'
      last_child_vals.each do |val|
        if val != 'declaration'
          throw SemanticException.new(first_child_val, last_child_vals)
        end
      end
      return 'varlist'
      
    
    # Releasing variables when we rise above their scope
    when first_child_val == 'free_variables'
      times_to_pop = $pop_count_stack.pop
      times_to_pop.times do
        variable = $scope_stack.pop
        $var_table.pop(variable)
      end
      return 'ignore'


    # While loop
    # keeps evaluating subsequent stuff so long as the first expression is true
    when first_child_class == While
      if last_child_vals[0].val == 'true'
        self.children[2..-1].each { |c| c.eval }
        self.children = children_copy
        self.eval
        return 'ignore'
      elsif last_child_vals[0].val == 'false'
        return 'ignore'
      else
        throw SemanticException.new(first_child_val, last_child_vals)
      end
      
      
    # If branch
    # Given two expressions, evaluates the second only if the first evaluates to true
    # Given three expressions, evaluates the second if the first evaluates to true, otherwise
    #  evaluates the third.
    when first_child_class == If
      if last_child_classes[0] == MBoolean
        if last_child_vals.length == 2 && last_child_vals[0].val == 'true'
          self.children[2].val = self.children[2].eval
        elsif last_child_vals.length == 3
          if last_child_vals[0].val == 'true'
            self.children[2].val = self.children[2].eval
          else
            self.children[3].val = self.children[3].eval
          end
        end
        return 'ignore'
      else
        throw SemanticException.new(first_child_val, last_child_vals)
      end
    
    
    when first_child_class == Print
      if last_child_vals[0].kind_of?(Token)
        puts last_child_vals[0].val
        return 'ignore'
      else
        throw SemanticException.new(first_child_val, last_child_vals)
      end
    
    
    when first_child_val.kind_of?(Type)
      return self.children[0].val
    
    
    # For things where we shouldn't evaluate a return value, like stdout or assignment.
    when first_child_val == 'ignore'
      # Do nothing
    
    
    # Undefined semantics
    else 
      throw SemanticException.new(first_child_val, last_child_vals)
    end
    
  end
  
  
  
  
  def gforth_val(type)
    vclass = val.class
    case type
    when 'float'
      case
      when MReal == vclass
        unless val.to_s.index('e') || val.to_s.index('E')
          return "#{val}e"
        else
          return val
        end
      when MInteger == vclass
        return "#{val}e"
      when val.kind_of?(Trig)
        return "f#{val}"
      when vclass == Exponent
        return 'fexp'
      when vclass == Modulo
        return 'fmod'
      else    
        return "f#{val}"
      end
      
    when 'integer'
      case
      when vclass == Exponent
        return 'exp'
      when vclass == Modulo
        return 'mod'
      else    
        return "#{val}"
      end
    
    when 'string'
      case
      when MString == vclass
        return "s\" #{val.val[1..-1]}"
      when vclass == Plus
        return 's+'
      end
      
    when 'boolean'
      if vclass == Not
        return 'invert'
      else
        return val
      end
    end
  end
  
  
  
  def print_tree depth=0
    children.each do |child|
      child.print_tree(depth + 1)
    end
    
    puts "\t" * depth + "#{val}" if val
  end
  
  
  
  def print_tree_finished depth=0
    puts "\t" * depth + "#{val}" if val
    
    children.each do |child|
      child.print_tree_finished(depth + 1)
    end
  end
  
end