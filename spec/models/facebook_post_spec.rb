require 'rails_helper'

RSpec.describe FacebookPost, type: :model do
  let(:post) { create(:facebook_post) }

  it { is_expected.to define_enum_for(:status) }

  it "has not_suspect status by default" do
    expect(post.status).to eq("not_suspect")
    expect(post.status_changed_at).to be_nil
  end

  describe "#change_status_to!" do
    it "sets status" do
      post.change_status_to!(:whitelisted)
      expect(post.status).to eq("whitelisted")
      expect(post.status_changed_at.to_s).to eq(Time.current.to_s)
    end
  end
end
