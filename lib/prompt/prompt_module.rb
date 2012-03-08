module Prompt
  VERSION = "0.1.0"

  class << self

    # Singleton instance
    #
    def application
      @application ||= Application.new
    end
  end
end
