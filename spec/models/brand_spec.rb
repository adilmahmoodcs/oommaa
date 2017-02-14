require 'rails_helper'

RSpec.describe Brand, type: :model do
  let(:brand) { create(:brand) }

  it "starts pages import after creation" do
    brand.run_callbacks(:commit)
    expect(PagesImporterJob).to have_been_enqueued.with(brand.name)
  end

  it "do not start import after update" do
    brand.run_callbacks(:commit) # after create
    brand.update_attribute(:name, "some name")
    brand.run_callbacks(:commit)
    expect(PagesImporterJob).to_not have_been_enqueued.with(brand.name)
  end
end
