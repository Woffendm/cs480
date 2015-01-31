# These represent lexographical ranges for characters. It's easier than making an array of actual characters by hand.
@lower_alpha = (97..122).map{ |i| i.chr }
@upper_alpha = (65..90).map{ |i| i.chr }
NUMERIC = (48..57).map{ |i| i.chr }
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

class Paren < Token
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
  LOWER_ALPHA = (97..122).map{ |i| i.chr }
  UPPER_ALPHA = (65..90).map{ |i| i.chr }
  NUMERIC = (48..57).map{ |i| i.chr }


# DEAL WITH END OF LINE / FILE
# Note that 'next' is the same as repeating the current character. 
def self.parse string, nofail=true, quite=true
  # Turn that mofo into an array
  string = string.each_char.to_a
  line = 0
  index = 0
  is_integer = false
  is_real = false
  is_string = false
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
          tokens << Paren.new(char)
        when ')'
          tokens << Paren.new(char)
        when '!'
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
        when 'l'
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
        when '"'
          token = char
          is_string = true
        #
        # Cases with ranges of characters
        #
        else
          case
          when NUMERIC.include?(char)
            token = char
            is_integer = true
          else
            throw ParseException.new line, index, char
          end
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
      when ':'
        case char
        when '='
          tokens << MAssign.new(token + char)
          token = nil
        else
          index -= 1
          token = nil
          throw ParseException.new line, index, string
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
      # let
      #
      when 'l'
        case char
        when 'e'
          token += char
        else
          index -= 1
          token = nil
          throw ParseException.new line, index, string
        end
      when 'le'
        case char
        when 't'
          tokens << MLet.new(token + char)
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
      # sin / stdout / string
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
      #
      # sin
      #
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
        when 'd'
          token += char
        else
          index -= 2
          token = nil
          throw ParseException.new line, index, string
        end
      #
      # stdout
      #
      when 'std'
        case char
        when 'o'
          token += char
        else
          index -= 3
          token = nil
          throw ParseException.new line, index, string
        end
      when 'stdo'
        case char
        when 'u'
          token += char
        else
          index -= 4
          token = nil
          throw ParseException.new line, index, string
        end
      when 'stdou'
        case char
        when 't'
          tokens << Type.new(token + char)
          token = nil
        else
          index -= 5
          token = nil
          throw ParseException.new line, index, string
        end
      #
      # string
      #
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
      #
      # tan
      #
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
      #
      # true
      #
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
      #
      # Non-keywords
      #
      else
        #
        # String
        #
        case
        when is_string
          case char
          when '"'
            tokens << MString.new(token + char)
            token = nil
            is_string = false
          else
            token += char
          end
        #
        # Integer
        #
        when is_integer
          case
          when NUMERIC.include?(char)
            token += char
          when char == '.' && NUMERIC.include?(next_char)
            is_integer = false
            is_real = true
            token += char
          else
            tokens << MInteger.new(token)
            index -= 1
            token = nil
            is_integer = false
          end
        #
        # Real
        #
        when is_real
          case
          when NUMERIC.include?(char)
            token += char
          else
            tokens << MReal.new(token)
            index -= 1
            token = nil
            is_real = false
          end
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