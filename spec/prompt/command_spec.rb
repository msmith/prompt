require 'prompt/command'
require 'prompt/parameter'
require 'prompt/glob_parameter'

include Prompt

describe Prompt::Command do

  DIRECTIONS = %w{n e s w}
  SPEEDS = %w{quickly slowly}

  describe "#match" do

    describe "hi" do

      it "matches correctly" do
        c = Command.new("hi")

        c.match("hi").should == []
        c.match("hi ").should == []
        c.match(" hi").should == []

        c.match("bye").should be_nil
        c.match("h").should be_nil
        c.match("").should be_nil
      end

    end

    describe "hi :name" do

      it "matches correctly" do
        c = Command.new("hi :name")

        c.match("hi guy").should == ["guy"]
        c.match("hi 'some guy'").should == ["some guy"]
        c.match("hi ''").should == [""]
        c.match('hi "some guy"').should == ["some guy"]
        c.match('hi ""').should == [""]

        c.match("hi '").should == ["'"]
        c.match('hi "').should == ['"']
        c.match('hi \'"').should == ['\'"']

        c.match("higuy").should be_nil
        c.match("higuy guy").should be_nil

        c.match(" hi guy").should == ["guy"]
        c.match("hi  guy").should == ["guy"]
        c.match("hi guy ").should == ["guy"]
      end

      it "matches correctly (with parameter value constraint)" do
        v = [Parameter.new(:name, "", %w{alice bob})]
        c = Command.new("hi :name", nil, v)

        c.match("hi alice").should == ["alice"]
        c.match("hi bob").should == ["bob"]
        c.match("hi zack").should be_nil
        c.match("hi ali").should be_nil
      end

    end

    describe "hi :first :last" do

      it "matches correctly" do
        c = Command.new("hi :first :last")

        c.match("hi agent smith").should == ["agent", "smith"]
        c.match("hi agent").should be_nil
        c.match("hi agent smith guy").should be_nil
      end

    end

    describe "say *stuff" do

      it "matches correctly" do
        c = Command.new("say *stuff")

        c.match("say hello").should == [["hello"]]
        c.match("say hello world").should == [["hello", "world"]]
        c.match("say hello  world").should == [["hello", "world"]]
        c.match("say  hello  world").should == [["hello", "world"]]
        c.match("say 'hello world'").should == [["hello world"]]
        c.match('say "hello world"').should == [["hello world"]]
      end

    end

    describe "say *stuff :adverb" do

      it "matches correctly" do
        c = Command.new("say *stuff :adverb")

        c.match("say hello").should be_nil
        c.match("say hello loudly").should == [["hello"], "loudly"]
        c.match("say hello world loudly").should == [["hello", "world"], "loudly"]
        c.match("say hello 'world loudly'").should == [["hello"], "world loudly"]
      end

    end

    describe "say *first *second" do

      it "matches correctly" do
        c = Command.new("say *first *second")

        c.match("say one").should be_nil
        c.match("say one two").should == [["one"], ["two"]]
        c.match("say one two three").should == [["one", "two"], ["three"]]
        c.match("say one 'two three'").should == [["one"], ["two three"]]
      end

    end

  end # describe "#match"

  describe "#parameters" do
    it "returns correctly" do
      color = Parameter.new(:color, "")
      flavor = Parameter.new(:flavor, "")

      Command.new("one").parameters.should == []
      vs = Command.new("one :color").parameters
      vs.length.should == 1
      vs.first.name.should == :color
      Command.new("one :color", nil, [color]).parameters.should == [color]
      Command.new("one :color", nil, [color, flavor]).parameters.should == [color]
    end
  end

  describe "#expansions" do
    it "expands correctly with no parameters" do
      Command.new("one").expansions.should == ["one"]
    end

    it "expands correctly with undefined parameters" do
      Command.new("go :dir").expansions.should == ["go <dir>"]
    end

    it "expands correctly with defined parameters" do
      v = [Parameter.new(:dir, "", DIRECTIONS), Parameter.new(:speed, "", SPEEDS)]
      Command.new("go :dir", nil, v).expansions.should == ["go n", "go e", "go s", "go w"]
      Command.new("go :dir :speed", nil, v).expansions.should ==
        ["go n quickly", "go n slowly",
         "go e quickly", "go e slowly",
         "go s quickly", "go s slowly",
         "go w quickly", "go w slowly"]
    end
  end

  describe "#usage" do
    it "returns correctly" do
      color = Parameter.new(:color, "")

      Command.new("one").usage.should == "one"
      Command.new("one :color").usage.should == "one <color>"
      Command.new("one :color", nil, [color]).usage.should == "one <color>"
      Command.new("one :color three").usage.should == "one <color> three"
    end
  end

end

