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

    def select_group desc
      @current_command_group_name = desc
    end

    def add_command command
      current_command_group.commands << command
    end

    def exec words
      commands.each do |command|
        args = command.match(words)
        return command.run(args) if args
      end
      raise CommandNotFound.new
    ensure
      clear_cached_values
    end

    def completions line_starting_with, word_starting_with
      args = Console.split(line_starting_with)
      arg_idx = word_index(line_starting_with)
      all_expansions(args[0,arg_idx], word_starting_with)
    end

    private

    def word_index line
      ss = StringScanner.new(line)
      ss.scan(/\s+/)
      idx = 0
      while ss.scan(/[^\s]+\s+/)
        idx += 1
      end
      idx
    end

    def clear_cached_values
      commands.each do |c|
        c.clear_cached_values
      end
    end

    def commands
      @command_groups.map(&:commands).flatten(1)
    end

    def all_expansions(args, partial_arg)
      commands.select { |c| c.start_with? args }.map do |c|
        c.expansions(args.length, partial_arg)
      end.flatten(1)
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
