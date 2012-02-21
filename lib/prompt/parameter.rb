module Prompt
  class Parameter

    attr :name
    attr :desc
    attr :values

    def initialize(name, desc, values = nil)
      @name = name
      @desc = desc
      @values = values
    end

    def regex
      if values
        "(?<#{name}>#{values.map{|v| Regexp.escape(v)}.join("|")})"
      else
        "(?<#{name}>([^#{Prompt::Command::SEP}]*))"
      end
    end

    def expansions
      values || ["<#{name}>"]
    end

    def matches s
      s
    end

  end
end
