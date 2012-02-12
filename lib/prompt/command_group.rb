module Prompt
  class CommandGroup
    attr_accessor :name
    attr :commands

    def initialize name
      @name = name
      @commands = []
    end

  end
end
