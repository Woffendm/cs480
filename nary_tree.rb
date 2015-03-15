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
      when [And, Or].include?(first_child_class)
        if last_child_classes == [MBoolean, MBoolean] 
          return send 'boolean', true
        else
          throw SemanticException.new(first_child_val, last_child_vals)
        end
      when first_child_class == Not
        if last_child_classes == [MBoolean] 
          return send 'boolean', true
        else
          throw SemanticException.new(first_child_val, last_child_vals)
        end
      
      else 
        
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