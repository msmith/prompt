require 'prompt'

include Prompt

describe Prompt::Console do
  describe ".split" do

    context "simple words" do
      {
        "hi"       => %w(hi),
        "one two"  => %w(one two),
        "one :two" => %w(one :two),
        "one *two" => %w(one *two),
        "one_two"  => %w(one_two)
      }.each do |line, words|
        it line do
          Console.split(line).should == words
        end
      end
    end

    context "extra whitespace" do
      {
        " hi"      => %w(hi),
        "hi "      => %w(hi),
        "   hi  "  => %w(hi),
        "one  two" => %w(one two),
      }.each do |line, words|
        it line do
          Console.split(line).should == words
        end
      end
    end

    context "quoted strings" do
      {
        "say 'hello'"     => %w(say hello),
        'say "hello"'     => %w(say hello),
        "say 'hi world'"  => ["say", "hi world"],
        'say "hi world"'  => ["say", "hi world"],
        'say ""'          => ["say", ""],
        "say ''"          => ["say", ""],
        "say '' ok"       => ["say", "", "ok"],
        "say 'hi  world'" => ["say", "hi  world"]
      }.each do |line, words|
        it line do
          Console.split(line).should == words
        end
      end
    end

    context "unmatched quotes" do
      {
        "'"          => %w('),
        '"'          => %w("),
        "alice's"    => %w(alice's),
        'alice"s'    => %w(alice"s),
        "'one' 'two" => %w(one 'two)
      }.each do |line, words|
        it line do
          Console.split(line).should == words
        end
      end
    end

    context "quoted with unqoted" do
      {
        "'one'two"     => %w(onetwo),
        "'one''two'"   => %w(onetwo),
        "'one'\"two\"" => %w(onetwo)
      }.each do |line, words|
        pending line do
          Console.split(line).should == words
        end
      end
    end

  end
end
