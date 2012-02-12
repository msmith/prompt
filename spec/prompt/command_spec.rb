require 'prompt/command'
require 'prompt/variable'

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

    it "matches correctly with a variable" do
      c = Command.new("hi :name")

      c.match("hi guy").should == ["guy"]
      c.match("higuy").should be_nil
      c.match("higuy guy").should be_nil
    end

    it "matches correctly with a variable and multiple spaces" do
      c = Command.new("hi :name")

      c.match(" hi guy").should == ["guy"]
      c.match("hi  guy").should == ["guy"]
      c.match("hi guy ").should == ["guy"]
    end

    it "matches correctly with 2 variables" do
      c = Command.new("hi :first :last")

      c.match("hi agent smith").should == ["agent", "smith"]
      c.match("hi agent").should be_nil
      c.match("hi agent smith guy").should be_nil
    end

    it "matches correctly with variable value constraint" do
      v = [Variable.new(:dir, "", DIRECTIONS)]
      c = Command.new("go :dir", nil, v)

      c.match("go n").should == ["n"]
      c.match("go s").should == ["s"]
      c.match("go x").should be_nil
      c.match("go nn").should be_nil
    end
  end

  describe "#variables" do
    it "returns correctly" do
      color = Variable.new(:color, "")
      flavor = Variable.new(:flavor, "")

      Command.new("one").variables.should == []
      vs = Command.new("one :color").variables
      vs.length.should == 1
      vs.first.name.should == :color
      Command.new("one :color", nil, [color]).variables.should == [color]
      Command.new("one :color", nil, [color, flavor]).variables.should == [color]
    end
  end

  describe "#expansions" do
    it "expands correctly with no variables" do
      Command.new("one").expansions.should == ["one"]
    end

    it "expands correctly with undefined variables" do
      Command.new("go :dir").expansions.should == ["go <dir>"]
    end

    it "expands correctly with defined variables" do
      v = [Variable.new(:dir, "", DIRECTIONS), Variable.new(:speed, "", SPEEDS)]
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
      color = Variable.new(:color, "")

      Command.new("one").usage.should == "one"
      Command.new("one :color").usage.should == "one <color>"
      Command.new("one :color", nil, [color]).usage.should == "one <color>"
      Command.new("one :color three").usage.should == "one <color> three"
    end
  end

end

