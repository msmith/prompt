module Prompt
  VERSION = "1.1.0"

  class << self

    # Singleton instance
    #
    def application
      @application ||= Application.new
    end
  end
end
