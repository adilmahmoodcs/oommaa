require 'rails_helper'

RSpec.describe PostsCSVExporter do
  subject { PostsCSVExporter }
  let(:correct_header_line) do
    "Published at,Blacklisted at,Brand,Licensor,Platform/Company,Facebook page,Message,Link to product"
  end

  before(:each) do
    10.times { create(:blacklisted_post) }
  end

  it "works as expected" do
    results = subject.new(FacebookPost.all).call.split("\n")
    expect(results.size).to be 11 # header + 10 posts
    expect(results.first).to eq(correct_header_line)
  end
end
