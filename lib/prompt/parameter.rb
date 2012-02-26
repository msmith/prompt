module Prompt
  class Parameter

    attr :name
    attr :desc
    attr :values

    def initialize(name, desc = nil, values = nil)
      @name = name
      @desc = desc
      @values = values
    end

    def regex
      "(?<#{name}>[^#{Prompt::Command::SEP}]*)"
    end

    def expansions(starting_with = "")
      if values
        values.select{ |v| v.start_with? starting_with }.map do |v|
          (v =~ /\s/) ?  "\"#{v}\"" : v
        end
      else
        []
      end
    end

    def matches s
      s
    end

  end
end
