require 'rails_helper'

RSpec.describe PagesImporterJob, type: :job do
  let(:brand) { create(:brand, name: @facebook_page_term) }

  before(:each) do
    allow_any_instance_of(FBPageSearcher).to receive(:token) { @facebook_token }
  end

  it "creates FacebookPage objects once" do
    VCR.use_cassette("fb_page_searcher", allow_playback_repeats: true) do
      expect{ PagesImporterJob.new.perform(brand.id) }.to change{ FacebookPage.count }.from(0)
      expect{ PagesImporterJob.new.perform(brand.id) }.to_not change{ FacebookPage.count }
    end
  end

  it "re-enqueue itself" do
    allow_any_instance_of(PagesImporterJob).to receive(:import_pages) # stub method
    expect{
      PagesImporterJob.new.perform(666)
    }.to(
      change(PagesImporterJob.jobs, :size).by(1)
    )

    expect(PagesImporterJob.jobs.first["args"]).to eq([666])
  end
end
