module Prompt
  VERSION = "0.0.2"

  class << self

    # Singleton instance
    #
    def application
      @application ||= Application.new
    end
  end
end
