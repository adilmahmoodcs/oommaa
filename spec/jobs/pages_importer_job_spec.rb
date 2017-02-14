require 'rails_helper'

RSpec.describe PagesImporterJob, type: :job do
  before(:each) do
    allow_any_instance_of(FBPageSearcher).to receive(:token) { @facebook_token }
  end

  it "creates FacebookPage objects once" do
    VCR.use_cassette("fb_page_searcher", allow_playback_repeats: true) do
      expect{ PagesImporterJob.perform_now(@facebook_page_term) }.to change{ FacebookPage.count }.from(0)
      expect{ PagesImporterJob.perform_now(@facebook_page_term) }.to_not change{ FacebookPage.count }
    end
  end

  it "re-enqueue itself" do
    allow_any_instance_of(PagesImporterJob).to receive(:perform) # stub method
    expect{ PagesImporterJob.perform_now(@facebook_page_term) }.to have_enqueued_job(PagesImporterJob).exactly(1)
  end
end
