module Prompt
  module DSLHelper

    # Split command into an array of Strings and Parameters
    def self.words command_name, parameters
      command_name.strip.split(/\s+/).map do |word|
         if word[0] == ":"
           sym = word[1..-1].to_sym
           parameters.find {|p| p.name == sym} || Parameter.new(sym)
         elsif word[0] == "*"
           sym = word[1..-1].to_sym
           param = parameters.find {|p| p.name == sym}
           # Since GlobParameters can't be defined ahead of time in the DSL, we
           # always create a new one and copy the description
           # This is kinda jankey
           desc = param ? param.desc : nil
           GlobParameter.new(sym, desc)
         else
           word
         end
      end
    end

  end
end
