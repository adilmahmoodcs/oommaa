require 'rails_helper'

RSpec.describe Domain, type: :model do
  subject { Domain }
  let(:domain_name) { "badsite.com" }
  let(:blacklisted_domain) { create(:domain, status: "blacklisted", name: domain_name) }
  let(:whitelisted_domain) { create(:domain, status: "whitelisted", name: domain_name) }
  let(:blacklisted_domain_post) { create(:facebook_post, status: "blacklisted", all_domains: [domain_name]) }
  let(:whitelisted_domain_post) { create(:facebook_post, status: "whitelisted", all_domains: [domain_name]) }

  describe ".blacklist!" do
    it "adds a blacklisted domain" do
      Domain.blacklist!(domain_name)
      expect(Domain.first.name).to eq(domain_name)
    end

    it "doesn't add duplicates" do
      3.times { Domain.blacklist!(domain_name) }
      expect(Domain.count).to eq(1)
    end
  end

  describe "#posts" do
    it "returns related posts" do
      blacklisted_domain_post
      expect(blacklisted_domain.posts).to eq([blacklisted_domain_post])
    end
  end

  describe "#update_posts!" do
    before(:each) do
      blacklisted_domain_post and whitelisted_domain_post
    end

    it "updates whitelisted posts if blacklisted" do
      blacklisted_domain.update_posts!
      expect(PostStatusJob.jobs.first["args"]).to eq ([whitelisted_domain_post.id])
    end

    it "updates blacklisted posts if whitelisted" do
      whitelisted_domain.update_posts!
      expect(PostStatusJob.jobs.first["args"]).to eq ([blacklisted_domain_post.id])
    end
  end
end
