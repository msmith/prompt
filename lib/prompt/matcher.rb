module Prompt
  class Matcher

    SEP = Prompt::Command::SEP

    attr :parameter

    def initialize param
      @parameter = param
    end

  end
end
