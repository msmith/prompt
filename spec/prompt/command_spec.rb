require 'prompt/command'
require 'prompt/parameter'
require 'prompt/glob_parameter'

include Prompt

describe Prompt::Command do

  DIRECTIONS = %w{n e s w}
  SPEEDS = %w{quickly slowly}

  describe "#match" do
    it "matches correctly" do
      c = Command.new("hi")

      c.match("hi").should == []
      c.match("hi ").should == []
      c.match(" hi").should == []

      c.match("bye").should be_nil
      c.match("h").should be_nil
      c.match("").should be_nil
    end

    it "matches correctly with a parameter" do
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
    end

    it "matches correctly with a parameter and multiple spaces" do
      c = Command.new("hi :name")

      c.match(" hi guy").should == ["guy"]
      c.match("hi  guy").should == ["guy"]
      c.match("hi guy ").should == ["guy"]
    end

    it "matches correctly with 2 parameters" do
      c = Command.new("hi :first :last")

      c.match("hi agent smith").should == ["agent", "smith"]
      c.match("hi agent").should be_nil
      c.match("hi agent smith guy").should be_nil
    end

    it "matches correctly with parameter value constraint" do
      v = [Parameter.new(:dir, "", DIRECTIONS)]
      c = Command.new("go :dir", nil, v)

      c.match("go n").should == ["n"]
      c.match("go s").should == ["s"]
      c.match("go x").should be_nil
      c.match("go nn").should be_nil
    end

    it "matches correctly with glob parameter" do
      c = Command.new("say *stuff")

      c.match("say hello").should == [["hello"]]
      c.match("say hello world").should == [["hello", "world"]]
      c.match("say hello  world").should == [["hello", "world"]]
      c.match("say  hello  world").should == [["hello", "world"]]
      c.match("say 'hello world'").should == [["hello world"]]
      c.match('say "hello world"').should == [["hello world"]]
    end

    it "matches correctly with glob parameter and other parameter" do
      c = Command.new("say *stuff :adverb")

      c.match("say hello").should be_nil
      c.match("say hello loudly").should == [["hello"], "loudly"]
      c.match("say hello world loudly").should == [["hello", "world"], "loudly"]
      c.match("say hello 'world loudly'").should == [["hello"], "world loudly"]
    end
  end

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

