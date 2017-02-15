require 'rails_helper'

RSpec.describe PostsImporterJob, type: :job do
  let(:page) { create(:facebook_page, facebook_id: @facebook_page_id) }

  before(:each) do
    allow_any_instance_of(FBPostSearcher).to receive(:token) { @facebook_token }
  end

  it "creates FacebookPost objects once" do
    VCR.use_cassette("fb_post_searcher", allow_playback_repeats: true) do
      expect{ PostsImporterJob.new.perform(page.id) }.to change{ FacebookPost.count }.from(0)
      expect{ PostsImporterJob.new.perform(page.id) }.to_not change{ FacebookPost.count }
    end
  end

  it "re-enqueue itself" do
    allow_any_instance_of(PostsImporterJob).to receive(:import_posts) # stub method
    expect {
      PostsImporterJob.new.perform(666)
    }.to change(PostsImporterJob.jobs, :size).by(1)

    expect(PostsImporterJob.jobs.first["args"]).to eq([666])
  end
end
