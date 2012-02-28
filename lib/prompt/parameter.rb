module Prompt
  class Parameter

    attr :name
    attr :desc

    def initialize(name, desc = nil, values = nil, &block)
      @name = name
      @desc = desc
      @values = values || []
      @proc = block if block_given?
    end

    def regex
      "(?<#{name}>[^#{Prompt::Command::SEP}]*)"
    end

    def clear_cached_values
      @cached_value = nil
    end

    def expansions(starting_with = "")
      all = if @proc
        @cached_value = @proc.call
      else
        @values
      end

      all.grep /^#{starting_with}/
    end

    def matches s
      s
    end

  end
end
