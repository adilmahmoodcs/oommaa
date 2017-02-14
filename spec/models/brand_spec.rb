require 'rails_helper'

RSpec.describe Brand, type: :model do
  let(:brand) { create(:brand) }

  it "starts pages import after creation" do
    brand.run_callbacks(:commit)
    expect(PagesImporterJob).to have_been_enqueued.with(brand)
  end

  it "do not start again after an update" do
    brand.run_callbacks(:commit)
    brand.update_attribute(:name, "some name")
    brand.run_callbacks(:commit)
    expect(PagesImporterJob).to have_been_enqueued.with(brand)
  end
end
