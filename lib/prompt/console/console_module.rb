require 'readline'
require 'prompt'
require 'strscan'

module Prompt
  module Console

    HISTORY_MAX_SIZE = 100

    CompletionProc = proc do |word_starting_with|
      line_starting_with = Readline.line_buffer[0...Readline.point]
      Prompt.application.completions(line_starting_with, word_starting_with)
    end

    def self.start(history_file = nil)
      # Store the state of the terminal
      stty_save = `stty -g`.chomp
      # and restore it when exiting
      at_exit do
        system('stty', stty_save)
        save_history history_file if history_file
      end

      Readline.completion_proc = CompletionProc

      load_history history_file if history_file

      while line = Readline.readline(Prompt.application.prompt, true)
        begin
          words = split(line)
          Prompt.application.exec words
        rescue CommandNotFound
          STDERR.puts "Command not found: #{line}"
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

    # Splits a command string into an argument (word) list.
    # This understands how to make "quoted strings" into a single word
    def self.split command
      args = []
      ss = StringScanner.new(command)
      ss.scan(/\s+/)
      until ss.eos?
        arg = ""
        while true
          segment = if ss.scan(S_QUOTED_ARG) or ss.scan(D_QUOTED_ARG)
            ss[1]
          else
            ss.scan(UNQUOTED_ARG)
          end
          break unless segment
          arg << segment
        end
        args << arg
        ss.scan(/\s+/)
      end
      args
    end


  end # module Console
end
