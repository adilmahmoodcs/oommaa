require 'rails_helper'

RSpec.describe Brand, type: :model do
  let(:brand) { create(:brand) }

  it "starts pages import after creation" do
    expect{ brand.run_callbacks(:commit) }.to have_enqueued_job(BrandPagesImporterJob)#.with(brand) # FIXME
  end

  it "do not start import after update" do
    brand.run_callbacks(:commit) # after create
    brand.update_attribute(:name, "some name")
    expect{ brand.run_callbacks(:commit) }.to_not have_enqueued_job(BrandPagesImporterJob)
  end
end
