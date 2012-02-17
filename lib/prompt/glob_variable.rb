module Prompt
  class GlobVariable < Variable

    def initialize(name, desc, &block)
      super(name, desc, nil)
      @proc = block
    end

    def regex
      "(.+)"
    end

  end
end
