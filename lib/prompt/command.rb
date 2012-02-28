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
      @parameters = words.select {|w| w.kind_of? Parameter}
    end

    def run args
      @action.call *args
    end

    def match words
      if m = regex.match(words.join(SEP))
        @parameters.map {|v| v.matches(m[v.name]) }
      end
    end

    def usage
      @words.map do |word|
        case word
        when GlobParameter
          "<#{word.name}> ..."
        when Parameter
          "<#{word.name}>"
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
      word = @words[0..word_idx].find { |w| w.kind_of? GlobParameter }
      word = word || @words[word_idx]

      return [] if word.nil?

      case word
      when Parameter
        word.expansions(starting_with)
      when String
        word.start_with?(starting_with) ? [word] : []
      end
    end

    def start_with?(args)
      args.zip(@words).all? do |a, w|
        w == a or w.kind_of?(Parameter)
      end
    end

    private

    def regex
      begin
        regex_strs = @words.map do |word|
           case word
           when Parameter
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
