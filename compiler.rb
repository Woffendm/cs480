require_relative './parser.rb'

class SemanticException < Exception  
  def initialize operator, &args
    super "Error: Undefined behavior for #{operator} with arguments #{args.join(', ')}."
  end
end




class Compiler
  # Create parse tree using parser and Tree class from Milestone1
  # Use post-order traversal bullcrap
  # 
  # 
  
  
  def self.compile_file file, nofail=false, quiet=true
    tree = Parser.parse_file(file)
    
    gforth_code = tree.to_gforth
    `echo '#{gforth_code}' > gforth.in`
    `gforth gforth.in`
  end

end