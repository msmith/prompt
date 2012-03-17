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

    def clear_cached_values
      @cached_values = nil
    end

    def completions(starting_with = "")
      all = if @proc
        @cached_values ||= @proc.call
      else
        @values
      end

      all.grep /^#{starting_with}/
    end

  end
end
