require 'strscan'
require 'prompt/parameter'

module Prompt
  class Command

    SEP = "\036" # RS - record separator
    S_QUOTED_ARG = /'([^']*)'/
    D_QUOTED_ARG = /"([^"]*)"/
    UNQUOTED_ARG = /[^\s]+/

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

    def match str
      if m = regex.match(to_args(str).join(SEP))
        @parameters.map {|v| v.matches(m[v.name]) }
      end
    end

    def expansions
      expand @words
    end

    def usage
      @words.map do |word|
        case word
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

    private

    # Splits a command string into an argument list.
    # This understands how to make "quoted strings" into a single arg
    def to_args command
      args = []
      ss = StringScanner.new(command)
      ss.scan(/\s+/)
      until ss.eos?
        if ss.scan(S_QUOTED_ARG) or ss.scan(D_QUOTED_ARG)
          args << ss[1]
        elsif arg = ss.scan(UNQUOTED_ARG)
          args << arg
        end
        ss.scan(/\s+/)
      end
      args
    end

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

    def expand a
      return [] if a.empty?

      head = a[0]
      tail = a[1..-1]

      case head
      when Parameter
        head = head.expansions
      else
        head = [head]
      end

      return head if tail.empty?

      result = []
      head.each do |h|
        expand(tail).each do |e|
          result << "#{h} #{e}"
        end
      end
      result
    end

  end
end
