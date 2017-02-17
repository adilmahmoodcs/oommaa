require 'rails_helper'

RSpec.describe DomainMatcher do
  subject { DomainMatcher }

  it "raise ArgumentError with missing arguments" do
    expect{subject.new.match?}.to raise_error(ArgumentError)
    expect{subject.new.match?(["term"])}.to_not raise_error
  end

  describe "#match?" do
    before(:each) do
      create(:domain, name: "first.com")
      create(:domain, name: "second.com")
    end

    it "returns true if any Domain matches" do
      expect(subject.new.match?(["nothing.com", "first.com"])).to be true
      expect(subject.new.match?(["second.com", "somethingelse.co.uk"])).to be true
    end

    it "returns false if no Domain matches" do
      expect(subject.new.match?(["somethingelse.co.uk"])).to be false
      expect(subject.new.match?(["first.co.uk"])).to be false
    end

    it "works with black terms" do
      expect(subject.new.match?([])).to be false
    end
  end
end
