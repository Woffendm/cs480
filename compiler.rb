require_relative './parser.rb'





class Compiler
  # Create parse tree using parser and Tree class from Milestone1
  # Use post-order traversal bullcrap
  # 
  # 
  
  
  def self.compile_file file, nofail=false, quiet=true
    puts "PARSE TREE:"
    tree = Parser.parse_file(file)
    puts "\n\nPROGRAM OUTPUT:"
    tree.eval
    puts "\n\nEVALUATED PARSE TREE:" unless quiet
    tree.print_tree_finished unless quiet
  end

end