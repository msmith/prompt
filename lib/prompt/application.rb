require 'prompt/command_group'
require 'prompt/command'
require 'prompt/matcher'
require 'prompt/simple_matcher'
require 'prompt/multi_matcher'

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
      last_idx = index_of_last_word(line_starting_with)
      all_completions(args[0,last_idx], word_starting_with)
    end

    def commands
      @command_groups.map(&:commands).flatten(1)
    end

    private

    def index_of_last_word line
      ss = StringScanner.new(line)
      ss.scan(/\s+/)
      idx = 0
      idx += 1 while ss.scan(/[^\s]+\s+/)
      idx
    end

    def clear_cached_values
      commands.each do |c|
        c.clear_cached_values
      end
    end

    def all_completions(args, partial_arg)
      commands.select { |c| c.could_match? args }.map do |c|
        c.completions(args.length, partial_arg)
      end.flatten(1).sort.uniq
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
