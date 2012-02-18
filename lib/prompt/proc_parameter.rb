module Prompt
  class ProcParameter < Parameter

    def initialize(name, desc, &block)
      super(name, desc, nil)
      @proc = block
    end

    def values
      @proc.call
    end

  end
end
