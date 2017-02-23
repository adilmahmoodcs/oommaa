require 'rails_helper'

RSpec.describe PagesImporterJob, type: :job do
  let(:brand) { create(:brand, name: @facebook_page_term) }
  let(:brand2) { create(:brand, name: @facebook_page_term_alternative) }

  before(:each) do
    allow_any_instance_of(FBPageSearcher).to receive(:token) { @facebook_token }
  end

  it "creates FacebookPage objects once" do
    VCR.use_cassette("fb_page_searcher", allow_playback_repeats: true) do
      expect{ PagesImporterJob.new.perform(brand.id) }.to change{ FacebookPage.count }.from(0)
      expect{ PagesImporterJob.new.perform(brand.id) }.to_not change{ FacebookPage.count }
    end
  end

  it "associate brand to page" do
    VCR.use_cassette("fb_page_searcher") do
      PagesImporterJob.new.perform(brand.id)
      expect(FacebookPage.last.brands).to eq([brand])
    end
  end

  it "adds new matching brands to exiting pages, once" do
    VCR.use_cassette("fb_page_searcher") do
      PagesImporterJob.new.perform(brand.id)
    end

    VCR.use_cassette("fb_page_searcher_alternative", allow_playback_repeats: true) do
      # this cassette has same content of fb_page_searcher...
      expect{ PagesImporterJob.new.perform(brand2.id) }.to_not change{ FacebookPage.count }
      expect(FacebookPage.last.brands).to eq([brand, brand2])
      PagesImporterJob.new.perform(brand2.id)
      expect(FacebookPage.last.brands).to eq([brand, brand2])
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

  it "starts posts import" do
    VCR.use_cassette("fb_page_searcher") do
      expect { PagesImporterJob.new.perform(brand.id) }.to(
        change(PostsImporterJob.jobs, :size)
      )
    end
  end
end
