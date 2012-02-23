module Prompt
  class GlobParameter < Parameter

    def initialize(name, desc = nil)
      super(name, desc)
    end

    def regex
      "(?<#{name}>(([^#{Prompt::Command::SEP}]*)#{Prompt::Command::SEP}?)+)"
    end

    def matches s
      s.split(Prompt::Command::SEP)
    end

  end
end
