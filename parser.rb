require_relative './scanner.rb'
require_relative './transitions.rb'

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
  
  attr_accessor :stack, :tokens, :index, :quiet
  
  def initialize
    @stack = Array.new
    @tokens = Array.new
    @index = 0
    @quiet = true
  end
  
  def transit transition, token, quiet=true
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



  def self.parse_file file, nofail=false, quiet=true,
    parser = Parser.new
    parser.tokens = Scanner.scan_file(file)
    parser.stack.push Start
    parser.quiet = quiet
   
    
    while parser.index <= parser.tokens.length
      begin        
        actual_token = parser.tokens[parser.index]
        token = actual_token.class
        puts "stack: #{parser.stack.to_s}" unless quiet
        puts "token: #{token.to_s}" unless quiet
        tos = parser.stack.pop

        # check if we're done
        if token == NilClass && tos.nil?
          return
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