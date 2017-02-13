require 'rails_helper'

RSpec.describe FBPostSearcher do
  subject { FBPostSearcher }
  let(:token) { "EAACEdEose0cBAAPkAqV2UjFwGKvgP93SOQYOKQOGMLFq7TC77Tbb7pbQJWsR8BjzEbOGJZAhTolTzSBDh86bq9RZCjVwnZB2VsfWh5oXMDhYLUX5hpyH3VQ5wl5svB9TZCUruX74RQorHRlZAPHzRyZC5QSPunV6NQSDtfrfXqdY9ZCZCEd04SJm" }
  let(:page_id) { "99559607813" }

  it "raise ArgumentError with missing arguments" do
    expect{subject.new}.to raise_error(ArgumentError)
    expect{subject.new(page_id: "12345")}.to raise_error(ArgumentError)
    expect{subject.new(token: "token")}.to raise_error(ArgumentError)
    expect{subject.new(page_id: "12345", token: "token")}.to_not raise_error
  end

  describe "#call" do
    it "return an array of facebook posts data" do
      result = VCR.use_cassette("fb_post_searcher") do
        subject.new(page_id: page_id, token: token, all_pages: false).call
      end

      expect(result.first["id"]).to be_present
      expect(result.first["message"]).to be_present
      expect(result.first["created_time"]).to be_present
      expect(result.first["permalink_url"]).to be_present
    end
  end
end
