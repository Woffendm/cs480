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
end


# Decide type based on first value
# Look at next value
# If next value is valid for this type, add it and continue
# Else, save current token, clear the space for the next one.
# All tokens' 'val' field is a string for now.
def parse string
  # Turn that mofo into an array
  string = string.each_char.to_a
  token = nil
  tokens = []
  string.each_with_index do |char, index|
    next_char = string[index + 1]
    
    if token
      # See if you can extend it!
      
      # A space is always the end of a token.
      if char == ' '
        tokens << token
        token = nil
      end
      
      puts token
      case token.class
      #
      #
      # => INTEGERS
      #
      #
      when MInteger
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
          throw ParseException.new
        # Something else
        else
          throw ParseException.new
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
          throw ParseException.new
        end
      #
      #
      # => REALS
      #
      #
      when MReal
        #
        # => Eval current char
        #
        case
        # It's a number
        when @numeric.include?(char)
          token.val += char
        # It's an . Error
        when char == '.'
          throw ParseException.new
        # Something else
        else
          throw ParseException.new
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
          throw ParseException.new
        end      
      end
      
      
    else
      # Make new one! Decide what kind it should be.
      case
      when @numeric.include?(char)
        token = MInteger.new(char)
      end 
    end    
    
  end
  
  return tokens
end