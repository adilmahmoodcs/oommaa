require 'rails_helper'

RSpec.describe FBPageSearcher do
  subject { FBPageSearcher }

  it "raise ArgumentError with missing arguments" do
    expect{subject.new}.to raise_error(ArgumentError)
    expect{subject.new(term: "term")}.to raise_error(ArgumentError)
    expect{subject.new(token: "token")}.to raise_error(ArgumentError)
    expect{subject.new(term: "term", token: "token")}.to_not raise_error
  end

  describe "#call" do
    it "return an array of facebook pages" do
      result = VCR.use_cassette("fb_page_searcher") do
        subject.new(term: "Dallas Cowboys", token: "some-token").call
      end

      expect(result).to be_a(Array)
    end
  end
end
