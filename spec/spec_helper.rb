require 'prompt/matcher'

def matcher(symbol_or_parameter)
  SimpleMatcher.new(param(symbol_or_parameter))
end

def multi_matcher(symbol_or_parameter)
  MultiMatcher.new(param(symbol_or_parameter))
end

def param(symbol_or_parameter)
  if symbol_or_parameter.kind_of? Parameter
    symbol_or_parameter
  else
    Parameter.new(symbol_or_parameter)
  end
end
