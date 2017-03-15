require 'rails_helper'

RSpec.describe LinksParser do
  subject { LinksParser }

  let(:sample_data) { [
    "https://github.com/", # no redirect
    "http://buff.ly/2kJE5fx", # short url
    "    http://buff.ly/2kJE5fx     ", # duplicated, useless spaces
    "",
    nil
  ] }

  let(:correct_result) { [
    "https://github.com/",
    "https://www.destroyallsoftware.com/blog/2017/the-biggest-and-weirdest-commits-in-linux-kernel-git-history?utm_content=bufferbed64&utm_medium=social&utm_source=plus.google.com&utm_campaign=buffer"
  ] }

  it "raise ArgumentError with missing arguments" do
    expect{subject.new.call}.to raise_error(ArgumentError)
  end

  it "works as expected" do
    VCR.use_cassette("links_parser") do
      expect(subject.new(sample_data).call).to eq(correct_result)
    end
  end
end
