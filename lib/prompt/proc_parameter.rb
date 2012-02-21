module Prompt
  class ProcParameter < Parameter

    def initialize(name, desc, &block)
      super(name, desc, nil)
      @proc = block
    end

    def values
      @cached_value ||= @proc.call
    end

    def clear_cached_value
      @cached_value = nil
    end

  end
end
