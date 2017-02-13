require 'rails_helper'

RSpec.describe Brand, type: :model do
  let(:brand) { create(:brand) }

  it "starts pages importer after creation" do
    expect{ brand.run_callbacks(:commit) }.to have_enqueued_job(BrandPagesImporterJob)#.with(brand) # FIXME
  end
end
