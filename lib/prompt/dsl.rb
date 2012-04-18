require 'prompt/parameter'
require 'prompt/dsl_helper'

module Prompt
  module DSL

    def self.extended(base)
      name = if base.respond_to? :name
        base.name
      else
        "Commands"
      end
      Prompt.application.select_group(name)
    end
    
    def desc text
      @@last_desc = text
    end

    def group desc
      Prompt.application.select_group(desc)
    end

    def command(name, desc = nil, &block)
      desc ||= @@last_desc
      @@last_desc = nil
      words = DSLHelper.words(name, @parameters || [])
      command = Command.new(words, desc, &block)
      Prompt.application.add_command(command)
    end

    def param(name, desc = nil, values = nil, &block)
      desc ||= @@last_desc
      @@last_desc = nil
      @parameters = [] unless defined? @parameters
      raise "parameter :#{name} is already defined" if @parameters.find {|v| v.name == name}
      @parameters << if block
        Parameter.new(name, desc, &block)
      else
        Parameter.new(name, desc, values)
      end
    end

  end
end
