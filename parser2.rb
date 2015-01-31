# These represent lexographical ranges for characters. It's easier than making an array of actual characters by hand.
@lower_alpha = (97..122).map{ |i| i.chr }
@upper_alpha = (65..90).map{ |i| i.chr }
@numeric = (48..57).map{ |i| i.chr }
@ops = ['+', '-', '*', '/', '%', '^', '=', '<', '>', '!']


class Token
  attr_accessor :val
  
  def initialize val
    self.val = val
  end
  
  def to_s
    "#{val}"
  end
end


class Operator < Token
end


class Comparison < Token
end


class Type < Token
end


class MBoolean < Type
  
end


class MInteger < Type
end


class MReal < MInteger
end


class MString < Type
  
end



class Constant < Token

end



class Variable < Token
  
end



class VariableList < Token
  
end



class Expression < Token
end



class Statement < Token
end



class MPrint < Statement
end



class MIf < Statement
end



class MWhile < Statement
end



class MLet < Statement
end



class MAssign < Statement
end


class ParseException < Exception  
  def initialize line=0, index=0, str='', msg=''
    super "Unexpected character '#{str[index]}' on #{line}:#{index}. #{msg}"
  end
end




class Parser

# Note that 'next' is the same as repeating the current character. 
def self.parse string, nofail=true, quite=true
  # Turn that mofo into an array
  line = 0
  index = 0
  string = string.each_char.to_a
  token = nil
  tokens = []
  while index <= string.length
    begin
      char = string[index]
      next_char = string[index + 1]
      case token
      when nil
        case char
        when nil
          break
        when ' '
          # do nothing
        when '+'
          tokens << Operator.new(char)
        when '-'
          tokens << Operator.new(char)
        when '*'
          tokens << Operator.new(char)
        when '/'
          tokens << Operator.new(char)
        when '%'
          tokens << Operator.new(char)
        when '^'
          tokens << Operator.new(char)
        when '='
          tokens << Comparison.new(char)
        when '>'
          token = char
        when '<'
          token = char
        when ':'
          token = char
        when '('
          tokens << Token.new(char)
        when ')'
          tokens << Token.new(char)
        when '!'
          token = char
        when '"'
          token = char
        when 'a'
          token = char
        when 'b'
          token = char
        when 'c'
          token = char
        when 'f'
          token = char
        when 'i'
          token = char
        when 'n'
          token = char
        when 'o'
          token = char
        when 's'
          token = char
        when 't'
          token = char
        when 'w'
          token = char
        else
          throw ParseException.new line, index, char
        end
      when '>'
        case char
        when '='
          tokens << Comparison.new(token + char)
          token = nil
        else
          tokens << Comparison.new(token)
          token = nil
          next
        end
      when '<'
        case char
        when '='
          tokens << Comparison.new(token + char)
          token = nil
        else
          tokens << Comparison.new(token)
          token = nil
          next
        end
      when '!'
        case char
        when '='
          tokens << Comparison.new(token + char)
          token = nil
        else
          tokens << Comparison.new(token)
          token = nil
          next
        end
      when 'a'
        case char
        when 'n'
          token += char
        else
          throw ParseException.new line, index - 1, string
          token = nil
          next
        end
      when 'an'
        case char
        when 'd'
          tokens << Comparison.new(token + char)
          token = nil
        else
          throw ParseException.new line, index - 2, string
          index -= 1
          token = nil
          next
        end
      when 'b'
        case char
        when 'o'
          token += char
        else
          throw ParseException.new line, index - 1, string
          token = nil
          next
        end
      when 'bo'
        case char
        when 'o'
          token += char
        else
          throw ParseException.new line, index - 2, string
          token = nil
          next
        end
      when 'boo'
        case char
        when 'l'
          tokens << Type.new(token + char)
          token = nil
        else
          throw ParseException.new line, index - 3, string
          index -= 2
          token = nil
          next
        end
      when 'c'
        case char
        when 'o'
          token += char
        else
          throw ParseException.new line, index - 1, string
          token = nil
          next
        end
      when 'co'
        case char
        when 's'
          tokens << Comparison.new(token + char)
          token = nil
        else
          throw ParseException.new line, index - 2, string
          index -= 1
          token = nil
          next
        end
      
        
      end
    # Rescue parse errors or let them DIE
    rescue Exception => e
      if nofail
        puts e unless quite
      else
        raise e
      end
    end
    
    index += 1
  end  
    
  return tokens
end


def self.run string
  puts parse(string).map{|t| t.to_s}
end


end