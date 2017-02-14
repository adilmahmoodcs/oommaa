require 'rails_helper'

RSpec.describe PostsImporterJob, type: :job do
  before(:each) do
    allow_any_instance_of(FBPostSearcher).to receive(:token) { @facebook_token }
  end

  it "creates FacebookPost objects once" do
    VCR.use_cassette("fb_post_searcher", allow_playback_repeats: true) do
      expect{ PostsImporterJob.perform_now(@facebook_page_id) }.to change{ FacebookPost.count }.from(0)
      expect{ PostsImporterJob.perform_now(@facebook_page_id) }.to_not change{ FacebookPost.count }
    end
  end

  it "re-enqueue itself" do
    allow_any_instance_of(PostsImporterJob).to receive(:perform) # stub method
    expect{ PostsImporterJob.perform_now(@facebook_page_id) }.to(
      have_enqueued_job(PostsImporterJob).exactly(1).with([@facebook_page_id])
    )
  end
end
