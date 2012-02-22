module Prompt
  module DSLHelper

    # Split command into an array of Strings and Parameters
    def self.words command_name, parameters
      command_name.strip.split(/\s+/).map do |word|
         if word[0] == ":"
           sym = word[1..-1].to_sym
           parameters.find {|v| v.name == sym} || Parameter.new(sym, sym.to_s)
         elsif word[0] == "*"
           sym = word[1..-1].to_sym
           parameters.find {|v| v.name == sym} || GlobParameter.new(sym, sym.to_s)
         else
           word
         end
      end
    end

  end
end
