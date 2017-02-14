require 'rails_helper'

RSpec.describe KeywordMatcher do
  subject { KeywordMatcher }

  it "raise ArgumentError with missing arguments" do
    expect{subject.new.match?}.to raise_error(ArgumentError)
    expect{subject.new.match?("term")}.to_not raise_error
  end

  describe "#call" do
    before(:each) do
      create(:keyword, name: "first keyword")
      create(:keyword, name: "second keyword")
    end

    it "returns true if any Keyword matches" do
      expect(subject.new.match?("trying the first keyword")).to be true
      expect(subject.new.match?("second keyword must match, too")).to be true
    end

    it "returns false if no Keyword matches" do
      expect(subject.new.match?("keyword")).to be false
      expect(subject.new.match?("keyword first")).to be false
      expect(subject.new.match?("trying random text")).to be false
    end

    it "works with nil term" do
      expect(subject.new.match?(nil)).to be false
    end
  end
end
