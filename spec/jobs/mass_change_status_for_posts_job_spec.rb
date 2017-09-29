require 'rails_helper'

RSpec.describe MassChangeStatusForPostsJob, type: :job do
  let!(:current_user) { create(:user) }
  let!(:post_whitelisted) { create(:facebook_post, mass_job_status: :to_be_whitelisted) }
  let!(:post_blacklisted) { create(:facebook_post, mass_job_status: :to_be_blacklisted) }
  let!(:post_ignored) { create(:facebook_post, mass_job_status: :to_be_ignored) }

  it "Should update the status to blacklisted " do
    VCR.use_cassette("synopsis", allow_playback_repeats: true) do
      expect{ MassChangeStatusForPostsJob.new.perform('blacklisted', current_user.id) }.to change{
        FacebookPost.unscoped.where(status: 3).count }.by(1)
    end
  end

  it "Should update the status to whitelisted " do
    VCR.use_cassette("synopsis", allow_playback_repeats: true) do
      expect{ MassChangeStatusForPostsJob.new.perform('whitelisted', current_user.id) }.to change{
        FacebookPost.unscoped.where(status: 2).count }.by(1)
    end
  end

  it "Should remove the Post with status to_be_ignored " do
    VCR.use_cassette("synopsis", allow_playback_repeats: true) do
      expect{ MassChangeStatusForPostsJob.new.perform('ignored', current_user.id) }.to change{
        FacebookPost.unscoped.count }.by(-1)
    end
  end
end
