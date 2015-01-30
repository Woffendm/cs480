# These represent lexographical ranges for characters. It's easier than making an array of actual characters by hand.
@lower_alpha = (97..122).map{ |i| i.chr }
@upper_alpha = (65..90).map{ |i| i.chr }
@numeric = (48..57).map{ |i| i.chr }

# TODO: Make this mixin actually work. The class constant doesn't work right now.
module HasOps
  def valid_op? char
    VALID_OPS.include? char
  end
end


class Token
  attr_accessor :val
  
  def initialize val
    self.val = val
  end
end


class Operator < Token
end


class Type < Token
  VALID_OPS = []
end


class MBoolean < Type
  
end


class MInteger < Type
  VALID_OPS = ['+', '-', '*', '/', '%', '^', '=', '<', '>', '<=', '>=', '!=']
  #extend HasOps
  def self.valid_op? char
    VALID_OPS.include? char
  end
end


class MReal < MInteger
  VALID_OPS = ['+', '-', '*', '/', '%', '^', '=', '<', '>', '<=', '>=', '!=']
  def self.valid_op? char
    VALID_OPS.include? char
  end
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


# Decide type based on first value
# Look at next value
# If next value is valid for this type, add it and continue
# Else, save current token, clear the space for the next one.
# All tokens' 'val' field is a string for now.
def parse string
  # Turn that mofo into an array
  line = 0
  string = string.each_char.to_a
  token = nil
  tokens = []
  string.each_with_index do |char, index|
    next_char = string[index + 1]
    
    if token
      # See if you can extend it!
      
      # A space, end of line, or end of file is always the end of a token.
      if [' ', '\n', nil].include? char
        tokens << token
        token = nil
        next
      end
      
      case 
      #
      #
      # => STRINGS
      #
      #
      when token.class == MString
        #
        # Eval current char
        #
        case
        # It's the end of the string
        when char == '"'
          token.val += char
          tokens << token
          token = nil
          next
        # It's some other character
        else
          token.val += char
        end
        
        #
        # Eval next char
        #
        # Throw exception if opening " is not matched with closing "
        if next_char == nil
          throw ParseException.new(line, index + 1, next_char, 'No closing quotations')
        end
      
      #
      #
      # => INTEGERS
      #
      #
      when token.class == MInteger
        #
        # Eval current char
        #
        case
        # It's a number. Okay
        when @numeric.include?(char)
          token.val += char
        # It's a . then a number. Convert token type
        when char == '.' && @numeric.include?(next_char)
          token = MReal.new(token.val + char)
          next
        # It's a . then something else. Error
        when char == '.'
          throw ParseException.new(line, index, char, 'Next character not numeric')
        # Something else
        else
          throw ParseException.new(line, index, char)
        end
        
        #
        # Eval next char
        #
        case
        # A number, a period, or a space
        when @numeric.include?(next_char) || next_char == '.' || next_char == ' '
          # Do nothing
        # A valid operator
        when MInteger.valid_op?(next_char)
          tokens << token
          token = nil
        # Something invalid
        else
          throw ParseException.new(line, index + 1, next_char)
        end
      #
      #
      # => REALS
      #
      #
      when token.class == MReal
        #
        # => Eval current char
        #
        case
        # It's a number
        when @numeric.include?(char)
          token.val += char
        # Something else
        else
          throw ParseException.new(line, index, char, 'Next character not numeric')
        end
        
        #
        # Eval next char
        #
        case
        # A number or a space
        when @numeric.include?(next_char) || next_char == ' '
          # Do nothing
        # A valid operator
        when MReal.valid_op?(next_char)
          tokens << token
          token = nil
        # Something invalid
        else
          throw ParseException.new(line, index + 1, next_char,)
        end      
      end
      
      
    else
      # Make new one! Decide what kind it should be.
      case
      when @numeric.include?(char)
        token = MInteger.new(char)
      when char == '"'
        token = MString.new(char)
      end 
      
    end    
    
  end
  
  return tokens
end