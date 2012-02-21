require 'prompt/command_group'
require 'prompt/command'

module Prompt
  class Application
    attr :command_groups
    attr_accessor :prompt

    def initialize
      @command_groups = []
      @prompt = "> "
    end

    def use_command_group desc
      @current_command_group_name = desc
    end

    def define_command name, desc = nil, parameters, &block
      current_command_group.commands << Command.new(name, desc, parameters, &block)
    end

    def exec command_str
      commands.each do |command|
        args = command.match(command_str)
        return command.run(args) if args
      end
      raise CommandNotFound.new(command_str)
    ensure
      clear_cached_values
    end

    def completions starting_with
      all_expansions.grep /^#{Regexp.escape(starting_with)}/
    end

    private

    def clear_cached_values
      commands.each do |c|
        c.clear_cached_values
      end
    end

    def commands
      @command_groups.map(&:commands).flatten(1)
    end

    def all_expansions
      commands.map(&:expansions).flatten(1)
    end

    def current_command_group
      command_groups.find { |cg| cg.name == @current_command_group_name } || begin
        cg = CommandGroup.new(@current_command_group_name)
        @command_groups << cg
        cg
      end
    end

  end
end
