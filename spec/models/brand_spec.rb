require 'rails_helper'

RSpec.describe Brand, type: :model do
  let(:brand) { create(:brand) }

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
end
