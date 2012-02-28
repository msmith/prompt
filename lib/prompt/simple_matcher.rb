module Prompt
  class SimpleMatcher < Matcher

    def regex
      "(?<#{parameter.name}>[^#{Prompt::Command::SEP}]*)"
    end

    def matches s
      s
    end

  end
end
