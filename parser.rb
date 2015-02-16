require_relative './scanner.rb'


class Transition
  def self.token?
    false
  end
  def self.has_first? token
    self.firsts.include? token
  end
  def self.transit token
    self.options.map{|o|o.first.firsts.include?(token)}.index(true)
  end
end

class Empty < Token
  def self.firsts
    return []
  end
end

class Start < Transition
  def self.firsts
    return LeftParen, Id, MInteger, MString, MReal, MBoolean
  end

  def self.options
    return [[LeftParen, Start3], [Expr, Start2]]
  end
end

class Start2 < Transition
  def self.firsts
    return self.options.map{|o|o.first.firsts}
  end
  def self.options
    return [[Start, Start2], [Empty]]
  end
end

class Start3 < Transition
  def self.firsts
    return self.options.map{|o|o.first.firsts} + [RightParen]
  end
  def self.options
    return [[RightParen, Start2], [Start, LeftParen, Start2]]
  end
end

class Expr < Transition
  def self.firsts
    return []
  end
  def self.options
    return [[]]
  end
end



class ParseException < Exception  
  def initialize token, msg=''
    super "Error: unexpected token #{token}. #{msg}"
  end
end





class Parser
  
  def self.push_to_stack stack, transition, index
    transition.options[index].reverse.each do |thing|
      stack.push thing
    end
    stack.pop
    return stack
  end



  def self.parse_file file, nofail=true, quiet=false,
    tokens = Scanner.scan_file(file)
    stack = Array.new
    index = 0
   
    
    while index <= tokens.length
      
      begin
        token = tokens[index]
        next_token = tokens[index + 1]
        stack.push Start if stack.empty?
        tos = stack.pop
        # If the top of the stack is a godamn token
        if tos.token?
          if token == tos
            # all good
          else
            # Was wrong token
            throw ParseException.new token
          end
        # The top of the stack is a bloody transition
        else
          if tos.has_first?(token.class)
            # keep refining stuff
            # Find out which option to choose
            q = tos.transit(token.class)
            push_to_stack stack, tos, q
          else
            # die
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