require 'rails_helper'

RSpec.describe PostStatusJob, type: :job do
  subject { PostStatusJob }
  let!(:domain) { create(:domain) }
  let!(:whitelisted_domain) { create(:domain, status: :whitelisted) }
  let!(:whitelisted_domain2) { create(:domain, status: :whitelisted) }
  let(:keyword) { create(:keyword) }
  let(:post) { create(:facebook_post) }
  let(:post_with_keyword) { create(:facebook_post, message: keyword.name) }
  let(:reported_to_facebook_post) { create(:facebook_post, status: :reported_to_facebook) }

  before do
    allow_any_instance_of(FacebookPost).to receive(:parse_all_links!)
  end

  describe "#perform" do
    it "calls #parse_all_links! on post" do
      expect_any_instance_of(FacebookPost).to receive(:parse_all_links!)
      subject.new.perform(post.id)
    end

    it "sets post as blacklisted if any domain matches blacklist" do
      allow_any_instance_of(FacebookPost).to receive(:all_domains) { [domain.name] }
      subject.new.perform(post.id)
      expect(post.reload.blacklisted?).to be true
    end

    it "does not change reported to facebook post status" do
      allow_any_instance_of(FacebookPost).to receive(:all_domains) { [domain.name] }
      subject.new.perform(reported_to_facebook_post.id)
      expect(reported_to_facebook_post.reload.status).to eq("reported_to_facebook")
    end

    it "sets keyword-matching post as suspect if any keyword matches" do
      subject.new.perform(post_with_keyword.id)
      expect(post_with_keyword.reload.suspect?).to be true
    end

    it "sets keyword-matching post as whitelisted if all domains matches whitelist" do
      allow_any_instance_of(FacebookPost).to receive(:all_domains) { [whitelisted_domain.name, whitelisted_domain2.name] }
      subject.new.perform(post_with_keyword.id)
      expect(post_with_keyword.reload.whitelisted?).to be true
    end

    it "does not set keyword-matching post as whitelisted if not all domains matches whitelist" do
      allow_any_instance_of(FacebookPost).to receive(:all_domains) { [whitelisted_domain.name, domain.name] }
      subject.new.perform(post_with_keyword.id)
      expect(post_with_keyword.reload.whitelisted?).to be false
    end

    it "keep post as not_suspect if none matches" do
      expect(post).to_not receive(:update_attributes!)
      subject.new.perform(post.id)
      expect(post.not_suspect?).to be true
    end
  end
end
