module Prompt
  VERSION = "0.0.3"

  class << self

    # Singleton instance
    #
    def application
      @application ||= Application.new
    end
  end
end
