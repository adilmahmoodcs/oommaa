require 'rails_helper'

RSpec.describe ShutDownCheckerJob, type: :job do
  let(:post) { create(:facebook_post) }

  it "updates #shut_down_by_facebook_at if post is shut down" do
    allow_any_instance_of(FBShutDownChecker).to receive_message_chain(:call).and_return(true)

    expect(post.shut_down_by_facebook_at).to be_nil
    ShutDownCheckerJob.new.perform(post.id)
    expect(post.reload.shut_down_by_facebook_at.utc.to_s).to eq(Time.now.utc.to_s)
  end

  it "re-enqueue itself if post is not shut down" do
    allow_any_instance_of(FBShutDownChecker).to receive_message_chain(:call).and_return(false)

    expect {
      ShutDownCheckerJob.new.perform(post.id)
    }.to change(ShutDownCheckerJob.jobs, :size).by(1)

    expect(post.shut_down_by_facebook_at).to be_nil
  end
end
