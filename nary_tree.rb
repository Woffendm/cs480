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
  
  
  
  def to_gforth
    return gforth_val if val
    return_values = []

    children.reverse.each do |child|
      return_values << child.to_gforth
    end

    return_values.join " "
  end
  
  
  
  def gforth_val
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
  
end