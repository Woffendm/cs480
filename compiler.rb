require_relative './parser.rb'





class Compiler
  # Create parse tree using parser and Tree class from Milestone1
  # Use post-order traversal bullcrap
  # 
  # 
  
  
  def self.compile_file file, nofail=false, quiet=true
    tree = Parser.parse_file(file)
    puts "\n\n"
    tree.eval
    tree.print_tree_finished
    
    #{}`echo '#{gforth_code}' > gforth.in`
    #{}`gforth gforth.in`
  end

end