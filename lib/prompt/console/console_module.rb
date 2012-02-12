require 'readline'
require 'prompt'

module Prompt
  module Console

    HISTORY_MAX_SIZE = 100
    PROMPT = "> "

    CompletionProc = proc do |s|
      Prompt.application.completions(s)
    end

    def self.start(history_file = nil)
      @prompt = PROMPT

      # Store the state of the terminal
      stty_save = `stty -g`.chomp
      # and restore it when exiting
      at_exit do
        system('stty', stty_save)
        save_history history_file if history_file
      end

      Readline.basic_word_break_characters = ""
      Readline.completion_append_character = " "
      Readline.completion_proc = CompletionProc

      load_history history_file if history_file

      while line = Readline.readline(@prompt, true)
        begin
          Prompt.application.exec(line).nil?
        rescue ::Prompt::CommandNotFound => e
          STDERR.puts e.message
        end
      end
    end

    def self.prompt= prompt
      @prompt = prompt
    end

    def self.prompt
      @prompt
    end

    def self.save_history file
      history_no_dups = Readline::HISTORY.to_a.reverse.uniq[0,HISTORY_MAX_SIZE].reverse
      File.open(file, "w") do |f|
        history_no_dups.each do |line|
          f.puts line
        end
      end
    end

    def self.load_history file
      if File.exist? file
        File.readlines(file).each do |line|
          Readline::HISTORY.push line.strip
        end
      end
    end

  end # module Console
end
