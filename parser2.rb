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


class Logic < Token
end


class Function < Token
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
          index -= 1
          token = nil
          throw ParseException.new line, index, string
        end
      #
      # and
      #
      when 'a'
        case char
        when 'n'
          token += char
        else
          index -= 1
          token = nil
          throw ParseException.new line, index, string
        end
      when 'an'
        case char
        when 'd'
          tokens << Logic.new(token + char)
          token = nil
        else
          index -= 2
          token = nil
          throw ParseException.new line, index, string
        end
      #
      # bool
      #
      when 'b'
        case char
        when 'o'
          token += char
        else
          index -= 1
          token = nil
          throw ParseException.new line, index, string
        end
      when 'bo'
        case char
        when 'o'
          token += char
        else
          index -= 2
          token = nil
          throw ParseException.new line, index, string
        end
      when 'boo'
        case char
        when 'l'
          tokens << Type.new(token + char)
          token = nil
        else
          index -= 3
          token = nil
          throw ParseException.new line, index, string
        end
      #
      # cos
      #
      when 'c'
        case char
        when 'o'
          token += char
        else
          index -= 1
          token = nil
          throw ParseException.new line, index, string
        end
      when 'co'
        case char
        when 's'
          tokens << Function.new(token + char)
          token = nil
        else
          index -= 2
          token = nil
          throw ParseException.new line, index, string
        end
      #
      # false
      #
      when 'f'
        case char
        when 'a'
          token += char
        else
          index -= 1
          token = nil
          throw ParseException.new line, index, string
        end
      when 'fa'
        case char
        when 'l'
          token += char
        else
          index -= 2
          token = nil
          throw ParseException.new line, index, string
        end
      when 'fal'
        case char
        when 's'
          token += char
        else
          index -= 3
          token = nil
          throw ParseException.new line, index, string
        end
      when 'fals'
        case char
        when 'e'
          tokens << MBoolean.new(token + char)
          token = nil
        else
          index -= 4
          token = nil
          throw ParseException.new line, index, string
        end
      #
      # if / int
      #
      when 'i'
        case char
        when 'f'
          tokens << MIf.new(token + char)
          token = nil
        when 'n'
          token += char
        else
          index -= 1
          token = nil
          throw ParseException.new line, index, string
        end
      when 'in'
        case char
        when 't'
          tokens << Type.new(token + char)
          token = nil
        else
          index -= 2
          token = nil
          throw ParseException.new line, index, string
        end
      #
      # not
      #
      when 'n'
        case char
        when 'o'
          token += char
        else
          index -= 1
          token = nil
          throw ParseException.new line, index, string
        end
      when 'no'
        case char
        when 't'
          tokens << Logic.new(token + char)
          token = nil
        else
          index -= 2
          token = nil
          throw ParseException.new line, index, string
        end
      #
      # or
      #
      when 'o'
        case char
        when 'r'
          tokens << Logic.new(token + char)
          token = nil
        else
          index -= 1
          token = nil
          throw ParseException.new line, index, string
        end
      #
      # sin / string
      #
      when 's'
        case char
        when 'i'
          token += char
        when 't'
          token += char
        else
          index -= 1
          token = nil
          throw ParseException.new line, index, string
        end
      when 'si'
        case char
        when 'n'
          tokens << Function.new(token + char)
          token = nil
        else
          index -= 2
          token = nil
          throw ParseException.new line, index, string
        end
      when 'st'
        case char
        when 'r'
          token += char
        else
          index -= 2
          token = nil
          throw ParseException.new line, index, string
        end
      when 'str'
        case char
        when 'i'
          token += char
        else
          index -= 3
          token = nil
          throw ParseException.new line, index, string
        end
      when 'stri'
        case char
        when 'n'
          token += char
        else
          index -= 4
          token = nil
          throw ParseException.new line, index, string
        end
      when 'strin'
        case char
        when 'g'
          tokens << Type.new(token + char)
          token = nil
        else
          index -= 5
          token = nil
          throw ParseException.new line, index, string
        end
      #
      # tan / true
      #
      when 't'
        case char
        when 'a'
          token += char
        when 'r'
          token += char
        else
          index -= 1
          token = nil
          throw ParseException.new line, index, string
        end
      when 'ta'
        case char
        when 'n'
          tokens << Function.new(token + char)
          token = nil
        else
          index -= 2
          token = nil
          throw ParseException.new line, index, string
        end
      when 'tr'
        case char
        when 'u'
          token += char
        else
          index -= 2
          token = nil
          throw ParseException.new line, index, string
        end
      when 'tru'
        case char
        when 'e'
          tokens << MBoolean.new(token + char)
          token = nil
        else
          index -= 3
          token = nil
          throw ParseException.new line, index, string
        end
      #
      # while
      #
      when 'w'
        case char
        when 'h'
          token += char
        else
          index -= 1
          token = nil
          throw ParseException.new line, index, string
        end
      when 'wh'
        case char
        when 'i'
          token += char
        else
          index -= 2
          token = nil
          throw ParseException.new line, index, string
        end
      when 'whi'
        case char
        when 'l'
          token += char
        else
          index -= 3
          token = nil
          throw ParseException.new line, index, string
        end
      when 'whil'
        case char
        when 'e'
          tokens << MWhile.new(token + char)
          token = nil
        else
          index -= 4
          token = nil
          throw ParseException.new line, index, string
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