require 'rails_helper'

RSpec.describe BrandMatcher do
  subject { BrandMatcher }
  let!(:brand1) { create(:brand, name: "First Name", nicknames: ["nick1", "nick-one"]) }
  let!(:brand2) { create(:brand, name: "Second Name", nicknames: ["nick2", "nick-two"]) }

  it "raise ArgumentError with missing arguments" do
    expect{subject.new}.to raise_error(ArgumentError)
    expect{subject.new("term")}.to_not raise_error
  end

  describe "call" do
    it "works as expected" do
      expect(subject.new("nothing").call).to eq([])
      expect(subject.new("first NAME").call).to eq([brand1.id])
      expect(subject.new("nick1").call).to eq([brand1.id])
      expect(subject.new("nick-one").call).to eq([brand1.id])
      expect(subject.new("first name or SECOND name").call).to eq([brand1.id, brand2.id])
      expect(subject.new("first name or nick2").call).to eq([brand1.id, brand2.id])
      expect(subject.new("nick-one or Second Name").call).to eq([brand1.id, brand2.id])
    end
  end
end
