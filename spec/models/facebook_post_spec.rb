require 'rails_helper'

RSpec.describe FacebookPost, type: :model do
  let(:post) { create(:facebook_post) }
  let(:post_with_links) {
    create(:facebook_post,
           message: "Get yours here >> http://bit.ly/2ksZpIv or here: https://bit.ly/2kHJRz3",
           link: "https://www.fanprint.com/products/tom-brady-goat-stats")
  }
  let(:post_with_fb_links) {
    create(:facebook_post,
           message: "Get yours here >> https://www.facebook.com/something or here: https://bit.ly/2kHJRz3",
           link: "https://www.facebook.com/fanprint/photos/a.469606039735992.116788.461431677220095/1531062416923677/?type=3")
  }
  let(:post_with_all_links) {
    create(:facebook_post, all_links: [
      "https://www.counterfind.com/something",
      "http://somedomain.co.uk/something",
      "http://somedomain.co.uk/something_else"
    ])
  }

  it { is_expected.to define_enum_for(:status) }

  it "has not_suspect status by default" do
    expect(post.status).to eq("not_suspect")
    expect(post.status_changed_at).to be_nil
  end

  describe "#change_status_to!" do
    it "can set whitelisted status" do
      post.change_status_to!(:whitelisted, "user@example.com")
      expect(post.status).to eq("whitelisted")
      expect(post.whitelisted_at.to_s).to eq(Time.current.to_s)
      expect(post.whitelisted_by).to eq("user@example.com")
    end

    it "can set blacklisted status" do
      post.change_status_to!(:blacklisted, "user@example.com")
      expect(post.status).to eq("blacklisted")
      expect(post.blacklisted_at.to_s).to eq(Time.current.to_s)
      expect(post.blacklisted_by).to eq("user@example.com")
    end

    it "can set suspect status" do
      post.change_status_to!(:suspect, "user@example.com")
      expect(post.status).to eq("suspect")
    end

    it "can set not_suspect status" do
      post.change_status_to!(:not_suspect, "user@example.com")
      expect(post.status).to eq("not_suspect")
    end
  end

  describe "#raw_links" do
    it "extract links from message and link attributes" do
      expect(post_with_links.raw_links).to eq([
        "http://bit.ly/2ksZpIv",
        "https://bit.ly/2kHJRz3",
        "https://www.fanprint.com/products/tom-brady-goat-stats"
      ])
    end

    it "skips facebook.com links" do
      expect(post_with_fb_links.raw_links).to eq(["https://bit.ly/2kHJRz3"])
    end
  end

  describe "#parse_all_links!" do
    it "parse and sets #all_links and #all_domains" do
      expect(post_with_links.all_links).to be_none
      expect(post_with_links.all_domains).to be_none

      VCR.use_cassette(:post_with_links_parser) do
        post_with_links.parse_all_links!
      end

      expect(post_with_links.all_links).to be_any
      expect(post_with_links.all_domains).to be_any
    end
  end
end
