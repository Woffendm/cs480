

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
    return [[RightParen, Start2], [Start, RightParen, Start2]]
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

class Binops < Transition
  def self.firsts
    return []
  end
  def self.options
    return [[Binops]]
  end
end

class Unops < Transition
  def self.options
    return [[Minus], [Not], [Sin], [Cos], [Tan]]
  end
end

class Oper < Transition
  def self.options
    return [[LeftParen, Assign, Id, Oper], [LeftParen, Binops, Oper, Oper], [LeftParen, Unops, Oper], [Constant], [Id]]
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
