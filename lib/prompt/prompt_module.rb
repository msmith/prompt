module Prompt
  class << self

    # Singleton instance
    #
    def application
      @application ||= Application.new
    end
  end
end
