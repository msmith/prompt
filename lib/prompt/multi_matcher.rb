module Prompt
  class MultiMatcher < Matcher

    def regex
      "(?<#{parameter.name}>([^#{SEP}]*)(#{SEP}[^#{SEP}]*)*)"
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
