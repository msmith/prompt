require 'prompt/dsl'

module Prompt
  module Console

    class Builtins
      extend DSL

      desc "Console commands"

      command "help -v" do
        print_help true
      end

      command "help" do
        print_help
      end

      command "exit" do
        exit
      end

      private

      def self.print_help verbose = false
        Prompt.application.command_groups.each do |cg|
          puts
          puts cg.name
          puts
          cg.commands.each do |cmd|
            puts "  %-40s %s" % [cmd.usage, cmd.desc]
            if verbose
              cmd.variables.each do |v|
                puts " "*43 + ("%-10s %s" % ["<#{v.name}>", "#{v.desc}"])
              end
            end
          end
        end
      end

    end # class Builtins

  end
end
