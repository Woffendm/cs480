require './scanner'

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
  
  
  
  # Performs a post-order traversal of the N-ary tree and returns the result in string form with
  # space delimited values
  def post_order
    return val.to_s if children.empty?
    return_values = []

    children.each do |child|
      return_values << child.post_order
    end

    return_values << val.to_s
    return_values.join " "
  end
  
  
  def remove_parens
    new_children = children.dup
    children.each do |child|
      unless [LeftParen, RightParen].include?(child.val.class)
        child = child.remove_parens
        new_children << child
      end
    end
    children = new_children
    self
  end
  
  
  
  # used for negation
  def negation_send type
    # Choose which stack to pop from
    case type
    when 'float'
      printer = 'fe.'
      neg = 'fneg'
    when 'integer'
      printer = '.'
      neg = 'neg'
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
      # Remove parenthesis
      if self.children.first.val.class == LeftParen
        self.children = self.children[1..-2]
      end
      
      # Ensure all children have types, so we can evaluate with semantics
      self.children.each do |child|
        unless child.val
          child.val = child.eval
        end
      end
      
      child_vals = self.children.map{|c|c.val}
      child_classes = child_vals.map{|c|c.class}
      first_child_val = child_vals[0]
      first_child_class = child_classes[0]
      
      last_child_vals = child_vals[1..-1]
      last_child_classes = child_classes[1..-1]
      
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
      
      else child_vals.first.kind_of? BinaryOperator
        # Convert everything to floats
        if child_vals.index(MReal)
          children[1..2].each do |c|
            if c.class != MReal
              c.val = c.val + 'e'
            end
          end
        end
      end
      
  end
  
  
  
  def to_gforth
    return gforth_val if val
    return_values = []

    children.reverse.each do |child|
      return_values << child.to_gforth
    end

    return_values.join " "
  end
  
  
  
  def gforth_val(type)
    vclass = val.class
    case type
    when 'float'
      case
      when MReal == vclass
        unless val.to_s.index('e')
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
      
    when 'string'
      
    end
    case 
    when MBoolean == val.class
      return val.downcase
    when MString == val.class
      return 's" ' + val + '"'
    when LeftParen == val.class      
      return nil
    when RightParen == val.class 
      return nil
    else    
      return val
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