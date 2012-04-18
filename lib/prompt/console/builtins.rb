require 'prompt/dsl'

module Prompt
  module Console

    class Builtins
      extend DSL

      group "Console commands"

      command "help", "List all commands" do
        print_help
      end

      command "help -v", "List all commands, including parameters" do
        print_help true
      end

      command "exit", "Exit the console" do
        exit
      end

      private

      def self.print_help verbose = false
        commands = Prompt.application.commands
        cmd_width = commands.map { |c| c.usage.length }.max

        Prompt.application.command_groups.each do |cg|
          puts
          puts cg.name
          puts
          cg.commands.each do |cmd|
            puts "  %-#{cmd_width+4}s %s" % [cmd.usage, cmd.desc]
            if verbose
              cmd.parameters.each do |v|
                puts " "*(cmd_width+7) + ("%-10s %s" % ["<#{v.name}>", "#{v.desc}"])
              end
            end
          end
        end
      end

    end # class Builtins

  end
end
