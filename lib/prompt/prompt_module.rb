module Prompt
  VERSION = "1.2.0"

  class << self

    # Singleton instance
    #
    def application
      @application ||= Application.new
    end
  end
end
