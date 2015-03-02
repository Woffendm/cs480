require_relative './scanner.rb'
require_relative './transitions.rb'
require_relative './nary_tree.rb'


class ParseException < Exception  
  def initialize token, msg=''
    super "Error: unexpected token #{token.class} on #{token.line}:#{token.index}. #{msg}"
  end
end

class EndOfFileException < Exception  
  def initialize token, msg=''
    super "Error: never received #{token}. #{msg}"
  end
end





class Parser
  
  attr_accessor :stack, :tokens, :index, :quiet, :tree
  
  def initialize
    @stack = Array.new
    @tokens = Array.new
    @index = 0
    @quiet = true
    @tree = NaryTree.new nil
    @tree_stack = [@tree]
  end
  
  def transit transition, token, quiet=false
    q = transition.options.map{|o|o.first.firsts.include?(token)}
    case q.count(true)
    when 0
      # No valid transition
      throw ParseException.new token, "No valid transition"
    when 1
      # Easy. One valid transition
      return q.index(true)
    else
      # More than one transition. Need to look ahead
      puts "Ambiguous transition! Oh no!" unless @quiet
      return q.index(true)
      
    end
  end
  
  
  # Adds token to tree's children
  def add_tree token
    @tree_stack.last.children << NaryTree.new(token)
  end
  
  
  # Called on left paren
  def push_tree
    new_node = NaryTree.new nil
    @tree_stack.last.children << new_node
    @tree_stack.push new_node
  end
  
  
  # Called on right paren
  def pop_tree
    @tree_stack.pop
  end
  
  
  #
  # => STILL HAVE AMBIGUITY BETWEEN STMT AND OPER
  #
  
  def push_to_stack transition, token
    transition.options[transit(transition, token)].reverse.each do |thing|
      @stack.push thing
    end
    if @stack.last.token?
      # We just read in the first token. Get rid of it from the stack
      @stack.pop
    else
      # We just read in the first token of some other transition. Need to resolve that transition 
      q = @stack.pop
      self.push_to_stack(q, token)
    end
  end



  def self.parse_file file, nofail=false, quiet=true
    parser = Parser.new
    parser.tokens = Scanner.scan_file(file)
    parser.stack.push Start
    parser.quiet = quiet
    depth = 0
    tree = 
    
    while parser.index <= parser.tokens.length
      begin        
        actual_token = parser.tokens[parser.index]
        token = actual_token.class
        #puts "stack: #{parser.stack.to_s}" unless quiet
        #puts "token: #{token.to_s}" unless quiet
        tos = parser.stack.pop

        # check if we're done
        if token == NilClass && tos.nil?
          parser.tree.print_tree
          return parser.tree
        elsif tos.nil?
          throw ParseException.new actual_token, "Tried to pop empty stack."
        end
        
        
        # If the top of the stack is a godamn token
        if tos.token?
          if token == tos
            # all good
          else
            # Was wrong token
            throw ParseException.new actual_token, "Expected: #{tos}"
          end
        # The top of the stack is a bloody transition
        else
          if tos.has_first?(token)
            # keep refining stuff
            # Find out which option to choose
            parser.push_to_stack tos, token
          elsif tos.has_first?(Empty)
            # skip the top of the stack since it can be empty.
            next
          else
            # die
            throw ParseException.new actual_token
          end
        end
        
        
        # Draw the little tree
        if token == RightParen
          depth -= 1
        end
        
        if actual_token
          # Print the tree
          puts "\t" * depth + token.to_s unless quiet
        end
        
        # Create actual tree structure
        if token == LeftParen
          depth += 1
          parser.push_tree
        end
        
        if actual_token
          parser.add_tree actual_token
        end
        
        if token == RightParen
          parser.pop_tree
        end

      
      rescue Exception => e
        if nofail
          puts e unless quiet
        else
          raise e
        end
      end
      
      parser.index += 1
    end
   
    if nofail
      parser.stack.each do |failure|
        puts "Error: never received #{failure}" unless quiet
      end
    else
      throw EndOfFileException.new parser.stack.first unless parser.stack.empty?
    end
  end



  def self.parse_and_print_file file
    self.parse_file file
  end

end