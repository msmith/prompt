module Prompt
  class GlobParameter < Parameter

    def initialize(name, desc, &block)
      super(name, desc, nil)
      @proc = block
    end

    def regex
      "(?<#{name}>(([^#{Prompt::Command::SEP}]*)#{Prompt::Command::SEP}?)+)"
    end

    def matches s
      s.split(Prompt::Command::SEP)
    end

  end
end
