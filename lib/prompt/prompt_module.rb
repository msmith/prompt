module Prompt
  VERSION = "1.2.2"

  class << self

    # Singleton instance
    #
    def application
      @application ||= Application.new
    end
  end
end
