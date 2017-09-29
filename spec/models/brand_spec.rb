require 'rails_helper'

RSpec.describe Brand, type: :model do
  let(:brand) { create(:brand) }
  let(:licensor) { create(:licensor) }

  it "starts pages import after creation" do
    expect { brand }.to(change(PagesImporterJob.jobs, :size).by(1))
  end

  it "do not start again after an update" do
    brand
    expect {
      brand.touch
    }.to_not(
      change(PagesImporterJob.jobs, :size)
    )
  end

  context "#update_facebook_pages" do
    before(:each) do
      brand.run_callbacks(:commit)
    end

    it "is called if licensor is changed" do
      expect(brand).to receive(:update_facebook_pages)

      brand.licensor = licensor
      brand.save
    end

    it "is not called if licensor is not changed" do
      expect(brand).to_not receive(:update_facebook_pages)

      brand.name = "something"
      brand.save
    end
  end
end
