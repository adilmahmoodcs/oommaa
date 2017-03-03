require 'rails_helper'

RSpec.describe BrandMatcher do
  subject { BrandMatcher }
  let!(:brand1) { create(:brand, name: "First Name") }
  let!(:brand2) { create(:brand, name: "Second Name") }

  it "raise ArgumentError with missing arguments" do
    expect{subject.new}.to raise_error(ArgumentError)
    expect{subject.new("term")}.to_not raise_error
  end

  describe "call" do
    it "works as expected" do
      expect(subject.new("nothing").call).to eq([])
      expect(subject.new("first NAME").call).to eq([brand1.id])
      expect(subject.new("first name or SECOND name").call).to eq([brand1.id, brand2.id])
    end
  end
end
