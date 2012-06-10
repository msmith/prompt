module Prompt
  class Parameter

    attr :name
    attr :desc

    def initialize(name, desc = nil, values = nil, &block)
      @name = name
      @desc = desc
      @values = values || []
      @proc = block if block_given?
      @cached_values = {}
    end

    def clear_cached_values
      @cached_values = {}
    end

    def completions(starting_with = "")
      all = if @proc
        @cached_values[starting_with] ||= @proc.call(starting_with)
      else
        @values
      end

      all.map(&:to_s).grep /^#{starting_with}/
    end

  end
end
