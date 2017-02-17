require 'rails_helper'

RSpec.describe PostStatusJob, type: :job do
  subject { PostStatusJob }
  let(:domain) { create(:domain) }
  let(:keyword) { create(:keyword) }
  let(:post) { create(:facebook_post) }
  let(:post_with_keyword) { create(:facebook_post, message: keyword.name) }

  describe "#perform" do
    it "calls #parse_all_links! on post" do
      expect_any_instance_of(FacebookPost).to receive(:parse_all_links!)
      subject.new.perform(post.id)
    end

    it "sets post as blacklisted if any domain matches" do
      allow_any_instance_of(FacebookPost).to receive(:all_domains) { [domain.name] }
      subject.new.perform(post.id)
      expect(post.reload.blacklisted?).to be true
    end

    it "sets post as suspect if any keyword matches" do
      subject.new.perform(post_with_keyword.id)
      expect(post_with_keyword.reload.suspect?).to be true
    end

    it "keep post as not_suspect if none matches" do
      expect(post).to_not receive(:update_attributes!)
      subject.new.perform(post.id)
      expect(post.not_suspect?).to be true
    end
  end
end
