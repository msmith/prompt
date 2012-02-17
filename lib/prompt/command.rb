module Prompt
  class Command

    attr :name
    attr :desc

    def initialize(name, desc = nil, all_variables = [], &block)
      @name = name
      @desc = desc
      @all_variables = all_variables
      @action = block
    end

    def run args
      @action.call *args
    end

    def match(str)
      if m = regex.match(str.strip)
        variables.map {|v| m[v.name.to_s] }
      end
    end

    def variables
      @variables ||= words.select {|w| w.kind_of? Variable}
    end

    def expansions
      expand words
    end

    def usage
      words.map do |word|
        case word
        when Variable
          "<#{word.name}>"
        else
          word
        end
      end.join(" ")
    end

    private

    def regex
      @regex ||= begin
        regex_strs = words.map do |word|
           case word
           when Variable
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
           @all_variables.find {|v| v.name == sym} || Variable.new(sym, sym.to_s)
         elsif word[0] == "*"
           sym = word[1..-1].to_sym
           @all_variables.find {|v| v.name == sym} || GlobVariable.new(sym, sym.to_s)
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
      when Variable
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
