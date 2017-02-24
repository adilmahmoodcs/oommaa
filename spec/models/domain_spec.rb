require 'rails_helper'

RSpec.describe Domain, type: :model do
  subject { Domain }
  let(:domain_name) { "badsite.com" }
  let(:domain) { create(:domain, name: domain_name) }
  let(:domain_post) { create(:facebook_post, all_domains: [domain_name]) }

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
      domain_post
      expect(domain.posts).to eq([domain_post])
    end
  end
end
