

class Token
  attr_accessor :val, :index, :line
  
  def firsts
    return [self.class]
  end
  
  def self.firsts
    return [self]
  end
  
  def token?
    true
  end
  
  def self.token?
    true
  end
  
  
  def initialize val
    self.val = val
    self.index = $index
    self.line = $line
  end
  
  def to_s
    "#{val}"
  end
end


class Id < Token
end



class Operator < Token
end

class Assign < Operator
end



class BinaryOperator < Operator
end

class Plus < BinaryOperator
end

class Minus < BinaryOperator
end

class Multiply < BinaryOperator
end

class Divide < BinaryOperator
end

class Modulo < BinaryOperator
end

class Exponent < BinaryOperator
end

class Equal < BinaryOperator
end

class LessThan < BinaryOperator
end

class LessThanEqual < BinaryOperator
end

class GreaterThan < BinaryOperator
end

class GreaterThanEqual < BinaryOperator
end

class NotEqual < BinaryOperator
end

class Or < BinaryOperator
end

class And < BinaryOperator
end



class UnaryOperator < Operator
end

class Not < UnaryOperator
end

class Trig < UnaryOperator
end

class Sin < Trig
end

class Cos < Trig
end

class Tan < Trig
end



class LeftParen < Token 
end

class RightParen < Token 
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




class Print < Token
end


class If < Token
end


class While < Token
end


class Let < Token
end
