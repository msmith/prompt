module Prompt
  class GlobParameter < Parameter

    SEP = Prompt::Command::SEP

    def initialize(name, desc = nil)
      super(name, desc)
    end

    def regex
      "(?<#{name}>([^#{SEP}]*)(#{SEP}[^#{SEP}]*)*)"
    end

    def matches s
      return [""] if s.length == 0
      ss = StringScanner.new(s)
      r = Regexp.new "[^#{SEP}]*"
      res = []
      until ss.eos?
        ss.scan /#{SEP}/
        res << ss.scan(r)
      end
      res
    end

  end
end
