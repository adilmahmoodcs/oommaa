require 'rails_helper'

RSpec.describe FBShutDownChecker do
  subject { FBShutDownChecker }

  it "raise ArgumentError with missing arguments" do
    expect{subject.new}.to raise_error(ArgumentError)
    expect{subject.new(object_id: "12345")}.to raise_error(ArgumentError)
    expect{subject.new(token: "token")}.to raise_error(ArgumentError)
    expect{subject.new(object_id: "12345", token: "token")}.to_not raise_error
  end

  describe "#call" do
    it "returns true if facebook object doesn't exist" do
      result = VCR.use_cassette("fb_shut_down_true") do
        subject.new(object_id: "377781842587879", token: @facebook_token).call
      end

      expect(result).to be true
    end

    it "returns false if facebook object exists" do
      result = VCR.use_cassette("fb_shut_down_false") do
        subject.new(object_id: "1484628094895311", token: @facebook_token).call
      end

      expect(result).to be false
    end
  end
end
