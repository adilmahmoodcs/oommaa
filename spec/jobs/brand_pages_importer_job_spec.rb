require 'rails_helper'

RSpec.describe BrandPagesImporterJob, type: :job do
  let(:brand) { create(:brand, name: @facebook_page_term) }

  before(:each) do
    allow_any_instance_of(FBPageSearcher).to receive(:token) { @facebook_token }
  end

  it "creates or updates FacebookPage objects" do
    VCR.use_cassette("fb_page_searcher", allow_playback_repeats: true) do
      expect{ BrandPagesImporterJob.perform_now(brand) }.to change{ FacebookPage.count }.from(0)
      expect{ BrandPagesImporterJob.perform_now(brand) }.to_not change{ FacebookPage.count }
    end
  end

  it "re-enqueue itself" do
    allow_any_instance_of(BrandPagesImporterJob).to receive(:perform) # stub method
    expect{ BrandPagesImporterJob.perform_now(brand) }.to have_enqueued_job(BrandPagesImporterJob).exactly(2)
  end
end
