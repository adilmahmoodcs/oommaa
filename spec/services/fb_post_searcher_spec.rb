require 'rails_helper'

RSpec.describe FBPostSearcher do
  subject { FBPostSearcher }
  let(:dates_test_data) do
      [
        { "created_time" => Time.now.strftime("%FT%T%:z"),},
        { "created_time" => 30.days.ago.strftime("%FT%T%:z"),},
        { "created_time" => 61.days.ago.strftime("%FT%T%:z")}
      ]
  end

  it "raise ArgumentError with missing arguments" do
    expect{subject.new}.to raise_error(ArgumentError)
    expect{subject.new(page_id: "12345")}.to raise_error(ArgumentError)
    expect{subject.new(token: "token")}.to raise_error(ArgumentError)
    expect{subject.new(page_id: "12345", token: "token")}.to_not raise_error
  end

  describe "#call" do
    it "return an array of facebook posts data" do
      result = VCR.use_cassette("fb_post_searcher") do
        subject.new(page_id: @facebook_page_id, token: @facebook_token, all_pages: false).call
      end

      expect(result.first["id"]).to be_present
      expect(result.first["message"]).to be_present
      expect(result.first["created_time"]).to be_present
      expect(result.first["permalink_url"]).to be_present
    end
  end

  describe "#filter_data" do
    it "discard data published more than 60 days ago" do
      expect(dates_test_data.size).to eq(3)
      expect(FBPostSearcher.new(page_id: "X", token: "X").filter_data(dates_test_data).size).to eq(2)

    end
  end
end
