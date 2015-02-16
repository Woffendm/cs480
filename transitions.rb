

class Transition
  def self.token?
    false
  end
  def self.has_first? token
    self.firsts.include? token
  end
  def self.firsts
    return self.options.map{|o|o.first.firsts}.flatten
  end
  def self.transit token
    q = self.options.map{|o|o.first.firsts.include?(token)}
    puts q.to_s
    q.index(true)
  end
end


class Empty < Token
  def self.firsts
    return [Empty]
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
  def self.options
    return [[Start, Start2], [Empty]]
  end
end


class Start3 < Transition
  def self.options
    return [[RightParen, Start2], [Start, RightParen, Start2], [Oper2, Start2]]
  end
end


class Expr < Transition
  def self.options
    return [[Oper], [Stmts]]
  end
end


class Stmts < Transition
  def self.firsts
    return []
  end
  def self.options
    return [[Stmts]]
  end
end

# Minus is not in here since it can be either unary or binary
class Binops < Transition
  def self.options
    return [[Plus], [Multiply], [Divide], [Modulo], [Exponent], [Equal], [GreaterThan],[LessThan],[LessThanEqual],[GreaterThanEqual],[NotEqual],[Or],[And]]
  end
end

# Minus is not in here since it can be either unary or binary
class Unops < Transition
  def self.options
    return [[Not], [Sin], [Cos], [Tan]]
  end
end

class Oper < Transition
  def self.options
    return [[LeftParen, Oper2], [Constant], [Id]]
  end
end

class Oper2 < Transition
  def self.options
    return [[Assign, Id, Oper, RightParen], [Binops, Oper, Oper, RightParen], [Unops, Oper, RightParen], [Minus, Oper, TMinus, RightParen]]
  end
end

class TMinus < Transition
  def self.options
    return [[Oper], [Empty]]
  end
end

class Constant < Transition
  def self.options
    return [[MInteger], [MReal], [TString]]
  end
end

class TString < Transition
  def self.options
    return [[MString], [MBoolean]]
  end
end
