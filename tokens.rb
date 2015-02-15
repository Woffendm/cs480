

class Token
  attr_accessor :val
  
  def initialize val
    self.val = val
  end
  
  def to_s
    "#{val}"
  end
end


class Id < Token
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
