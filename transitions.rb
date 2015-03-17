

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
    return [[LeftParen, Start3], [Constant, Start2], [Id, Start2]]
  end
end


class Start2 < Transition
  def self.options
    return [[Start, Start2], [Empty]]
  end
end


class Start3 < Transition
  def self.options
    return [[RightParen, Start2], [Start, RightParen, Start2], [Expr2, Start2]]
  end
end


class Expr < Transition
  def self.options
    return [[LeftParen, Expr2], [Constant], [Id]]
  end
end

class Expr2 < Transition
  def self.options
    return [[Oper2], [Stmts2]]
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




class Stmts < Transition
  def self.options
    return [[LeftParen, Stmts2]]
  end
end

class Stmts2 < Transition
  def self.options
    return [[If, Expr, Expr, TIf, RightParen], [While, Expr, Exprlist, RightParen],[Print, Oper, RightParen],[Let,LeftParen,Varlist,RightParen,RightParen]]
  end
end


class Exprlist < Transition
  def self.options
    return [[Expr, Exprlist2]]
  end
end


class Exprlist2 < Transition
  def self.options
    return [[Exprlist],[Empty]]
  end
end

class TIf < Transition
  def self.options
    return [[Expr],[Empty]]
  end
end

class Varlist < Transition
  def self.options
    return [[LeftParen, Id, Type,RightParen,Varlist2]]
  end
end

class Varlist2 < Transition
  def self.options
    return [[Varlist],[Empty]]
  end
end