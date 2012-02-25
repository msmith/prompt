require 'readline'
require 'prompt'

module Prompt
  module Console

    HISTORY_MAX_SIZE = 100

    CompletionProc = proc do |s|
      Prompt.application.completions(s)
    end

    def self.start(history_file = nil)
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

      while line = Readline.readline(Prompt.application.prompt, true)
        begin
          words = split(line)
          Prompt.application.exec words
        rescue ::Prompt::CommandNotFound => e
          STDERR.puts e.message
        end
      end
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

    private

    S_QUOTED_ARG = /'([^']*)'/
    D_QUOTED_ARG = /"([^"]*)"/
    UNQUOTED_ARG = /[^\s]+/

    # Splits a command string into a word list.
    # This understands how to make "quoted strings" into a single word
    def self.split command
      args = []
      ss = StringScanner.new(command)
      ss.scan(/\s+/)
      until ss.eos?
        if ss.scan(S_QUOTED_ARG) or ss.scan(D_QUOTED_ARG)
          args << ss[1]
        elsif arg = ss.scan(UNQUOTED_ARG)
          args << arg
        end
        ss.scan(/\s+/)
      end
      args
    end


  end # module Console
end
