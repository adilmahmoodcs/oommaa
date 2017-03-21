require 'rails_helper'

RSpec.describe LinksParser do
  subject { LinksParser }

  let(:sample_data) { [
    "https://github.com/", # no redirect
    "http://buff.ly/2kJE5fx", # short url
    "    http://buff.ly/2kJE5fx     ", # duplicated, useless spaces
    "https://www.wattpad.com/385894833-yenilmezler-mutant-çağı-dominic", # non ascii
    "https://www.sunfrog.com/DIE-HARD-DC1-1300-SportsGrey-39696434-Hoodie.html", # 404
    "",
    nil
  ] }

  let(:correct_result) { [
    "https://github.com/",
    "https://www.destroyallsoftware.com/blog/2017/the-biggest-and-weirdest-commits-in-linux-kernel-git-history?utm_content=bufferbed64&utm_medium=social&utm_source=plus.google.com&utm_campaign=buffer",
    "https://www.wattpad.com/385894833-yenilmezler-mutant-%C3%A7a%C4%9F%C4%B1-dominic",
    "https://www.sunfrog.com/DIE-HARD-DC1-1300-SportsGrey-39696434-Hoodie.html"
  ] }

  it "raise ArgumentError with missing arguments" do
    expect{subject.new.call}.to raise_error(ArgumentError)
  end

  it "works as expected" do
    # TODO find a way to use a VCR cassette
    WebMock.disable!
    expect(subject.new(sample_data).call).to eq(correct_result)
    WebMock.enable!
  end
end
