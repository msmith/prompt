require 'prompt/simple_matcher'
require 'prompt/multi_matcher'

module Prompt
  module DSLHelper

    # Split command into an array of Strings and Matchers
    def self.words command_name, parameters
      command_name.strip.split(/\s+/).map do |word|
        if word[0] == ":"
          param = find_param word, parameters
          SimpleMatcher.new param
        elsif word[0] == "*"
          param = find_param word, parameters
          MultiMatcher.new param
        else
          word
        end
      end
    end

    def self.find_param word, parameters
      sym = word[1..-1].to_sym
      parameters.find {|p| p.name == sym} || Parameter.new(sym)
    end

  end
end
