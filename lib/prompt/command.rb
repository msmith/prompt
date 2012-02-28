require 'strscan'
require 'prompt/parameter'
require 'prompt/console/console_module'

module Prompt
  class Command

    SEP = "\036" # RS - record separator

    attr :name
    attr :desc
    attr :parameters

    def initialize(words, desc = nil, &block)
      @words = words
      @desc = desc
      @action = block

      @name = words.join(" ")
      @matchers = words.select {|w| w.kind_of?(Matcher) }
      @parameters = @matchers.map { |m| m.parameter }
    end

    def run args
      @action.call *args
    end

    def match words
      if args = regex.match(words.join(SEP))
        @matchers.map {|m| m.matches(args[m.parameter.name]) }
      end
    end

    def usage
      @words.map do |word|
        case word
        when MultiMatcher
          "<#{word.parameter.name}> ..."
        when Matcher
          "<#{word.parameter.name}>"
        else
          word
        end
      end.join(" ")
    end

    def clear_cached_values
      @parameters.each do |p|
        p.clear_cached_value if p.respond_to?(:clear_cached_value)
      end
    end

    def expansions(word_idx, starting_with)
      # TODO - combine glob parameters with any that follow
      word = @words[0..word_idx].find { |w| w.kind_of? MultiMatcher }
      word = word || @words[word_idx]

      return [] if word.nil?

      case word
      when Matcher 
        word.parameter.expansions(starting_with)
      when String
        word.start_with?(starting_with) ? [word] : []
      end
    end

    def could_match?(words)
      words.each_with_index do |w, i|
        word = @words[i]
        case word
        when nil
          return false
        when MultiMatcher
          return true
        when String
          return false unless word.start_with?(w)
        end
      end
      return true
    end

    private

    def regex
      begin
        regex_strs = @words.map do |word|
           case word
           when Matcher
             word.regex
           else
             Regexp.escape(word)
           end
        end
        Regexp.new("^#{regex_strs.join(SEP)}$")
      end
    end

  end
end
