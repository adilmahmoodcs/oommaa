require 'rails_helper'

RSpec.describe FacebookPost, type: :model do
  let(:post) { create(:facebook_post) }
  let(:post_with_links) {
    create(:facebook_post,
           message: "Get yours here >> http://bit.ly/2ksZpIv or here: https://bit.ly/2kHJRz3 this is invalid: http://",
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

    it "can set ignored status" do
      post.change_status_to!(:ignored, "user@example.com")
      expect(post.status).to eq("ignored")
    end

    it "can set reported_to_facebook status" do
      post.change_status_to!(:reported_to_facebook, "user@example.com")
      expect(post.status).to eq("reported_to_facebook")
      expect(post.reported_to_facebook_at.to_s).to eq(Time.current.to_s)
      expect(post.reported_to_facebook_by).to eq("user@example.com")
    end

    it "cannot change status form reported_to_facebook" do
      post.change_status_to!(:reported_to_facebook, "user@example.com")
      post.change_status_to!(:blacklisted, "user@example.com")
      expect(post.status).to eq("reported_to_facebook")
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

  describe "#final_status?" do
    it "only true for reported_to_facebook status" do
      expect(build(:facebook_post, status: :not_suspect).final_status?).to be(false)
      expect(build(:facebook_post, status: :suspect).final_status?).to be(false)
      expect(build(:facebook_post, status: :whitelisted).final_status?).to be(false)
      expect(build(:facebook_post, status: :blacklisted).final_status?).to be(false)
      expect(build(:facebook_post, status: :ignored).final_status?).to be(false)

      expect(build(:facebook_post, status: :reported_to_facebook).final_status?).to be(true)
    end
  end
end
