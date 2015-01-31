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
  def initialize line=0, index=0, char='', msg=''
    super "Unexpected character '#{char}' on #{line}:#{index}. #{msg}"
  end
end



# Note that 'next' is the same as repeating the current character. 
def parse string
  # Turn that mofo into an array
  line = 0
  index = 0
  string = string.each_char.to_a
  token = nil
  tokens = []
  while index <= string.length
    puts index
    char = string[index]
    next_char = string[index + 1]
    case token
    when nil
      case char
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
        ParseException.new line, index, char
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
    when '='
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
        ParseException.new line, index - 1, token
        token = nil
        next
      end
      
      
    end
    
    index += 1
  end  
    
  return tokens
end


def run string
  puts parse(string).map{|t| t.to_s}
end


