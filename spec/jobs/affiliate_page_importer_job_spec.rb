require 'rails_helper'

RSpec.describe AffiliatePageImporterJob, type: :job do

  before(:each) do
    allow_any_instance_of(FBPageSearcher).to receive(:token) { @facebook_token }
  end

  it "creates FacebookPage objects once" do
    VCR.use_cassette("fb_page_searcher", allow_playback_repeats: true) do
      expect{ AffiliatePageImporterJob.new.perform(@facebook_page_term) }.to change{ FacebookPage.count }.from(0)
    end
  end

  it "creates FacebookPage objects with status (affiliate_page)" do
    VCR.use_cassette("fb_page_searcher", allow_playback_repeats: true) do
      expect{ AffiliatePageImporterJob.new.perform(@facebook_page_term) }.to change{ FacebookPage.affiliate_page.count }.from(0)
    end
  end

  it "creates only one FacebookPage objects if page url is present" do
    VCR.use_cassette("fb_page_searcher", allow_playback_repeats: true) do
      expect{ AffiliatePageImporterJob.new.perform(@facebook_page_name,@facebook_page_url) }.to change{ FacebookPage.affiliate_page.count }.by(1)
    end
  end
end
