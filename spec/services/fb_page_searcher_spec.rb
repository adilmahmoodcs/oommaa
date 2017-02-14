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
    it "return an array of facebook pages data" do
      result = VCR.use_cassette("fb_page_searcher_limit_10") do
        subject.new(term: @facebook_page_term, token: @facebook_token, all_pages: false, limit: 10).call
      end

      expect(result.first["id"]).to be_present
      expect(result.first["name"]).to be_present
    end
  end
end
