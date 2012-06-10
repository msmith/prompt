require 'prompt'
require 'spec_helper'

include Prompt

describe Prompt::Command do

  DIRECTIONS = %w{n e s w}
  SPEEDS = %w{slow slower}

  describe "#match" do

    describe "hi" do

      it "matches correctly" do
        c = Command.new ["hi"]

        c.match(["hi"]).should == []

        c.match(["bye"]).should be_nil
        c.match(["h"]).should be_nil
        c.match([""]).should be_nil
      end

    end

    describe "hi :name" do

      it "matches correctly" do
        c = Command.new ["hi", matcher(:name)]

        c.match(["hi", "guy"]).should == ["guy"]
        c.match(["hi", "some guy"]).should == ["some guy"]
        c.match(["hi", ""]).should == [""]

        c.match(["higuy"]).should be_nil
        c.match(["higuy", "guy"]).should be_nil
      end

      it "matches correctly (with parameter value constraint)" do
        name = Parameter.new(:name, "", ["alice", "bob", "charlie rose"])
        c = Command.new ["hi", matcher(name)]

        c.match(["hi", "alice"]).should == ["alice"]
        c.match(["hi", "bob"]).should == ["bob"]
        c.match(["hi", "charlie rose"]).should == ["charlie rose"]
        c.match(["hi", "zack"]).should == ["zack"]
      end

    end

    describe "hi :first :last" do

      it "matches correctly" do
        c = Command.new ["hi", matcher(:first), matcher(:last)]

        c.match(%w(hi agent smith)).should == ["agent", "smith"]

        c.match(%w(hi agent)).should be_nil
        c.match(%w(hi agent smith guy)).should be_nil
      end

    end

    describe "say *stuff" do

      it "matches correctly" do
        c = Command.new ["say", multi_matcher(:stuff)]

        c.match(["say", "hello"]).should == [["hello"]]
        c.match(["say", "hello", "world"]).should == [["hello", "world"]]
        c.match(["say", ""]).should == [[""]]
        c.match(["say", "hello", ""]).should == [["hello", ""]]
      end

    end

    describe "say *stuff :adverb" do

      it "matches correctly" do
        c = Command.new ["say", multi_matcher(:stuff), matcher(:adverb)]

        c.match(["say", "hello", "world"]).should == [["hello"], "world"]
        c.match(["say", "hello", "world", "loudly"]).should == [["hello", "world"], "loudly"]
        c.match(["say", "hello", "world loudly"]).should == [["hello"], "world loudly"]

        c.match(["say", "hello"]).should be_nil
      end

    end

    describe "say *first *second" do

      it "matches correctly" do
        c = Command.new ["say", multi_matcher(:first), multi_matcher(:second)]

        c.match(["say", "one"]).should be_nil
        c.match(["say", "one", "two"]).should == [["one"], ["two"]]
        c.match(["say", "one", "two", "three"]).should == [["one", "two"], ["three"]]
        c.match(["say", "one", "two three"]).should == [["one"], ["two three"]]
      end

    end

  end # describe "#match"

  describe "#parameters" do
    it "returns correctly" do
      color = Parameter.new(:color, "")
      flavor = Parameter.new(:flavor, "")

      Command.new(["one"]).parameters.should == []
      Command.new(["one", matcher(color)]).parameters.should == [color]
      Command.new(["one", matcher(color), matcher(flavor)]).parameters == [color, flavor]
    end
  end

  describe "#completions" do

    it "expands correctly with no parameters" do
      c = Command.new ["one"]
      c.completions(0, "").should == ["one"]
      c.completions(0, "on").should == ["one"]
      c.completions(0, "z").should == []
      c.completions(1, "").should == []

      c = Command.new ["help", "-v"]
      c.completions(0, "").should == ["help"]
      c.completions(0, "he").should == ["help"]
      c.completions(0, "z").should == []
      c.completions(1, "").should == ["-v"]
      c.completions(1, "-v").should == ["-v"]
      c.completions(1, "z").should == []
    end

    it "expands correctly with undefined parameters" do
      c = Command.new(["go", matcher(:dir)])
      c.completions(0, "").should == ["go"]
      c.completions(0, "g").should == ["go"]
      c.completions(0, "go").should == ["go"]
      c.completions(1, "").should == []
    end

    it "expands correctly with defined parameters" do
      dir = Parameter.new(:dir, "", DIRECTIONS)
      c = Command.new(["go", matcher(dir)])
      c.completions(1, "").should == DIRECTIONS

      speed = Parameter.new(:speed, "", SPEEDS)
      c = Command.new(["go", matcher(dir), matcher(speed)])
      c.completions(2, "").should == SPEEDS
      c.completions(2, "slow").should == SPEEDS
      c.completions(2, "slowe").should == ["slower"]
    end

    it "expands correctly if parameter values have spaces" do
      speed = Parameter.new(:speed, "", ["fast", "very fast"])
      c = Command.new(["go", matcher(speed)])
      c.completions(1, "").should == ['fast', 'very fast']
      c.completions(1, "f").should == ['fast']
      c.completions(1, "v").should == ['very fast']
    end

    it "expand correctly if parameter values are not strings" do
      nums = Parameter.new(:numbers, "", [1, 2, 3, 10])
      c = Command.new(["guess", matcher(nums)])
      c.completions(1, "1").should == ["1", "10"]
      c.completions(1, "2").should == ["2"]
      c.completions(1, "9").should == []
    end

    it "expands correctly when *param is followed by :param" do
      speed = Parameter.new(:speed, "", SPEEDS)
      dir = Parameter.new(:dir, "", DIRECTIONS)
      c = Command.new [multi_matcher(speed), matcher(dir)]
      c.completions(0, "").should == SPEEDS
      c.completions(1, "").should == (SPEEDS + DIRECTIONS)
      c.completions(2, "").should == (SPEEDS + DIRECTIONS)
      c.completions(1, "s").should == (SPEEDS + DIRECTIONS).grep(/^s/)
    end

    it "caches dynamic parameters" do
      year = Parameter.new(:year, "", "") do
        Range.new(1, 100).to_a.map &:to_s
      end
      c = Command.new [matcher(year)]
      Range.should_receive(:new).once.and_return(["42"])
      c.completions(0, "").should == ["42"]
      c.completions(0, "").should == ["42"] # this time it should be cached
      c.clear_cached_values
      Range.should_receive(:new).once.and_return(["44"])
      c.completions(0, "").should == ["44"]
    end

  end

  describe "#usage" do
    it "returns correctly" do
      color = Parameter.new(:color, "")

      Command.new(["one"]).usage.should == "one"
      Command.new(["one", matcher(color)]).usage.should == "one <color>"
      Command.new(["one", matcher(color), "three"]).usage.should == "one <color> three"
    end
  end

end

