module Prompt
  class Command

    attr :name
    attr :desc

    def initialize(name, desc = nil, all_parameters = [], &block)
      @name = name
      @desc = desc
      @all_parameters = all_parameters
      @action = block
    end

    def run args
      @action.call *args
    end

    def match(str)
      if m = regex.match(str.strip)
        parameters.map {|v| m[v.name.to_s] }
      end
    end

    def parameters
      @parameters ||= words.select {|w| w.kind_of? Parameter}
    end

    def expansions
      expand words
    end

    def usage
      words.map do |word|
        case word
        when Parameter
          "<#{word.name}>"
        else
          word
        end
      end.join(" ")
    end

    private

    def regex
      begin
        regex_strs = words.map do |word|
           case word
           when Parameter
             word.regex
           else
             Regexp.escape(word)
           end
        end
        Regexp.new("^#{regex_strs.join("\s+")}$")
      end
    end

    def words
      @words ||= @name.split(/\s/).map do |word|
         if word[0] == ":"
           sym = word[1..-1].to_sym
           @all_parameters.find {|v| v.name == sym} || Parameter.new(sym, sym.to_s)
         elsif word[0] == "*"
           sym = word[1..-1].to_sym
           @all_parameters.find {|v| v.name == sym} || GlobParameter.new(sym, sym.to_s)
         else
           word
         end
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
