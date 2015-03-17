require_relative './tokens.rb'


class VariableTypeError < Exception  
  def initialize variable, key, value
    super "Error: Attempted to assign #{value} to variable #{key} of type #{variable.type}"
  end
end


class UnassignedVariableException < Exception  
  def initialize variable
    super "Error: Unassigned variable #{variable}."
  end
end


class UndeclaredVariableException < Exception  
  def initialize variable
    super "Error: Undeclared variable #{variable}."
  end
end




class VarTable  
  
  attr_accessor :table

  def initialize
    @table = {}
  end
  
  
  def declare(var, type)
    case
    when type =='int'
      type = MInteger 
    when type == 'real'
      type = MReal 
    when type == 'bool'
      type = MBoolean 
    when type == 'string'
      type = MString 
    end
    if @table[var]
      @table[var].push(Variable.new(type))
    else
      @table[var] = [Variable.new(type)]
    end
  end
  
  
  def assign(var, value)
    variable = get(var)
    if value.class == variable.type
      variable.val = value
    else
      throw VariableTypeError.new(variable, var, value)
    end
  end


  def pop(var)
    @table[var].pop
  end
  
  
  def get(var)
    array = @table[var]
    if array.nil? || (variable = array.last).nil?
      throw UndeclaredVariableException.new(var)
    end
    variable
  end
  
  
  def get_val(var)
    variable = get(var)
    throw UnassignedVariableException.new(var) unless variable.val
    variable.val
  end
  
  
  def get_type(var)
    variable = get(var)
    throw UndeclaredVariableException.new(var) unless variable.type
    variable.type
  end
  
end



class Variable
  
  attr_accessor :val, :type
  
  def initialize(type)
    self.type = type
  end
  
end