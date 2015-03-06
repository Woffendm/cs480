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
  
  
  
  # This actually runs gforth crap and returns something
  def send type
    case type
    when 'float'
      printer = 'f.'
    when 'integer'
      printer = '.'
    end
    gforth_string = children.reverse.map{|c| c.gforth_val(type) }.join(" ")
    `echo '#{gforth_string} #{printer} bye' > gforth.in`
    `gforth gforth.in > gforth.out`
    result = Scanner.scan_file('gforth.out').first
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
      
      if first_child_val.kind_of? Trig
        if last_child_classes != [MReal]
          throw SemanticException.new(first_child_val, last_child_vals)
        else
          return send 'float'
        end
      elsif child_vals.first.kind_of? BinaryOperator
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
    case type
    when 'float'
      case
      when MReal == val.class
        unless val.to_s.index('e')
          return "#{val}e"
        else
          return val
        end
      when MInteger == val.class
        return val + 'e'
      when MString == val.class
        return 's" ' + val + '"'
      when val.kind_of?(Trig)
        return "f#{val}"
      else    
        return val
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