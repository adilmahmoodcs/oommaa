require 'rails_helper'

RSpec.describe PostsImporterJob, type: :job do
  let(:page) { create(:facebook_page, facebook_id: @facebook_page_id) }

  before(:each) do
    allow_any_instance_of(FBPostSearcher).to receive(:token) { @facebook_token }
  end

  it "creates FacebookPost objects once" do
    VCR.use_cassette("fb_post_searcher", allow_playback_repeats: true) do
      expect{ PostsImporterJob.perform_now(page) }.to change{ FacebookPost.count }.from(0)
      expect{ PostsImporterJob.perform_now(page) }.to_not change{ FacebookPost.count }
    end
  end

  # it "re-enqueue itself" do
  #   allow_any_instance_of(PostsImporterJob).to receive(:perform) # stub method
  #   expect{ PostsImporterJob.perform_now(page) }.to(
  #     have_enqueued_job(PostsImporterJob).exactly(1).with([page])
  #   )
  # end
end
