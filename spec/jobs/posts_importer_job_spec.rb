require 'rails_helper'

RSpec.describe PostsImporterJob, type: :job do
  let(:page) { create(:facebook_page, facebook_id: @facebook_page_id) }
  # because non matching pages are skipped
  let!(:brand) { create(:brand, name: page.name) }

  before(:each) do
    allow_any_instance_of(FBPostSearcher).to receive(:token) { @facebook_token }
  end

  it "creates FacebookPost objects once" do
    VCR.use_cassette("fb_posts_searcher", allow_playback_repeats: true) do
      expect{ PostsImporterJob.new.perform(page.id) }.to change{ FacebookPost.count }.from(0)
      expect{ PostsImporterJob.new.perform(page.id) }.to_not change{ FacebookPost.count }
    end
  end

  it "clears two-components facebook ids" do
    VCR.use_cassette("fb_posts_searcher") do
      PostsImporterJob.new.perform(page.id)
      expect(FacebookPost.count).to be > 0

      FacebookPost.find_each do |post|
        expect(post.facebook_id).not_to include("_")
      end
    end
  end

  it "re-enqueue itself" do
    allow_any_instance_of(PostsImporterJob).to receive(:import_posts) # stub method
    expect {
      PostsImporterJob.perform_async(666)
    }.to change(PostsImporterJob.jobs, :size).by(1)

    expect(PostsImporterJob.jobs.first["args"]).to eq([666])
  end

  it "calls PostStatusJob" do
    VCR.use_cassette("fb_posts_searcher", allow_playback_repeats: true) do
      expect(PostStatusJob).to receive(:perform_async).at_least(2).times
      PostsImporterJob.new.perform(page.id)
    end
  end

  it "does not create FacebookPost with no external links" do
    VCR.use_cassette("fb_posts_searcher_with_no_links") do
      expect{ PostsImporterJob.new.perform(page.id) }.to_not change{ FacebookPost.count }
    end
  end
end
