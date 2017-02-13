require 'rails_helper'

RSpec.describe FBPageSearcher do
  subject { FBPageSearcher }
  let(:token) { "EAAIUKbXn8xsBAPsYb2xKl4fcrpDnJKQZCrZB2EuLjHyg4GrXrlqnd1xHROqV3DFFbPRuzILTEwtoXLr5fo8PTxvvyN68uPUpbvCwnoIPrdJLmmKkuJXd2dMGekT8THoc2eZBuftIVXaLTN656NYzpxOu9FtG10ZD" }

  it "raise ArgumentError with missing arguments" do
    expect{subject.new}.to raise_error(ArgumentError)
    expect{subject.new(term: "term")}.to raise_error(ArgumentError)
    expect{subject.new(token: "token")}.to raise_error(ArgumentError)
    expect{subject.new(term: "term", token: "token")}.to_not raise_error
  end

  describe "#call" do
    it "return an array of facebook pages data" do
      result = VCR.use_cassette("fb_page_searcher") do
        subject.new(term: "Dallas Cowboys", token: token).call
      end

      expect(result.first["id"]).to be_present
      expect(result.first["name"]).to be_present
      expect(result.first["link"]).to be_present
      expect(result.first["picture"]).to be_present
    end
  end
end
