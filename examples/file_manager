#!/usr/bin/env ruby

$: << File.join(File.dirname(__FILE__), "../lib")

require 'prompt'
require 'prompt/console'

extend Prompt::DSL

@pwd = File.absolute_path Dir.pwd

dynamic_variable :dir, "Directory" do
  Dir.entries(@pwd).select do |e|
    File.directory? e
  end
end

command "cd :dir", "Change directory" do |dir|
  @pwd = File.absolute_path File.join(@pwd, dir)
end

command "ls", "List files" do
  puts @pwd
  puts Dir.entries(@pwd)
end

command "pwd", "Print current directory" do
  puts @pwd
end

Prompt::Console.start
