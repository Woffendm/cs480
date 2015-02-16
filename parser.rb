require_relative './scanner.rb'
require_relative './transitions.rb'

class ParseException < Exception  
  def initialize token, msg=''
    super "Error: unexpected token #{token}. #{msg}"
  end
end





class Parser
  
  def self.push_to_stack stack, transition, token
    transition.options[transition.transit(token)].reverse.each do |thing|
      stack.push thing
    end
    if stack.last.token?
      # We just read in the first token. Get rid of it from the stack
      stack.pop
    else
      # We just read in the first token of some other transition. Need to resolve that transition 
      q = stack.pop
      stack = self.push_to_stack(stack, q, token)
    end
    return stack
  end



  def self.parse_file file, nofail=false, quiet=false,
    tokens = Scanner.scan_file(file)
    stack = Array.new
    index = 0
    stack.push Start
   
    
    while index <= tokens.length
      begin        
        token = tokens[index].class
        next_token = tokens[index + 1].class
        puts "stack:"
        puts stack.to_s
        tos = stack.pop

        # check if we're done
        if token == NilClass && tos.nil?
          return
        end
        
        # If the top of the stack is a godamn token
        if tos.token?
          if token == tos
            # all good
          else
            # Was wrong token
            throw ParseException.new token, "Expected: #{tos}"
          end
        # The top of the stack is a bloody transition
        else
          if tos.has_first?(token)
            # keep refining stuff
            # Find out which option to choose
            push_to_stack stack, tos, token
          elsif tos.has_first?(Empty)
            puts 'testo'
            # skip the top of the stack since it can be empty.
            next
          else
            # die
            puts '!!!!!!'
            throw ParseException.new token
          end
        end
      
      rescue Exception => e
        if nofail
          puts e unless quiet
        else
          raise e
        end
      end
      
      index += 1
    end
   
   
   # 
   # while index <= tokens.length
   #   
   #   begin
   #     token = tokens[index]
   #     next_token = tokens[index + 1]
   #     
   #     case token
   #     when LeftParen
   #       stack.push RightParen
   #     when RightParen
   #       unless stack.pop == RightParen
   #         throw ParseException.new token
   #       end
   #     end
   #     
   #   rescue Exception => e
   #     if nofail
   #       puts e unless quiet
   #     else
   #       raise e
   #     end
   #   end
   #   
   #   index += 1
   # end
   # 
    if nofail
      stack.each do |failure|
        puts "Error: never received #{failure}"
      end
    else
      throw ParseException.new stack.first unless stack.empty?
    end
  end



  def self.parse_and_print_file file
    self.parse_file file
  end

end