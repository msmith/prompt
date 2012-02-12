module Prompt
  class CommandNotFound < RuntimeError
    def initialize(command_str)
      super "Command not found: #{command_str}"
    end
  end
end
