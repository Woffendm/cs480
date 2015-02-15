require_relative './scanner.rb'


class Transition
  
end


class Start < Transition
  #[LParen, RParen]
  #[LParen, Start, RParen]
  #[Start, Start]
  #[Expr]
end


class ParseException < Exception  
  def initialize token, msg=''
    super "Unexpected token #{token}. #{msg}"
  end
end




class Parser

  def self.parse_file file
    tokens = Scanner.scan_file(file)
    stack = Array.new
    index = 0
    
    while index <= tokens.length
      
      begin
        token = tokens[index]
        next_token = tokens[index + 1]
        
        
      rescue Exception => e
        raise e
      end
      
    end
  end



  def self.parse_and_print_file file
    
  end

end