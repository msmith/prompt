require 'prompt/parameter'
require 'prompt/proc_parameter'
require 'prompt/glob_parameter'

module Prompt
  module DSL

    def self.extended(base)
      name = if base.respond_to? :name
        base.name
      else
        "Commands"
      end
      Prompt.application.use_command_group(name)
    end

    def desc desc
      Prompt.application.use_command_group(desc)
    end

    def command(name, desc = nil, &block)
      Prompt.application.define_command(name, desc, @parameters || {}, &block)
    end

    def param(name, desc, values = nil, &block)
      @parameters = [] unless defined? @parameters
      raise "parameter :#{name} is already defined" if @parameters.find {|v| v.name == name}
      if block
        @parameters << ProcParameter.new(name, desc, &block)
      else
        @parameters << Parameter.new(name, desc, values)
      end
    end

  end
end
