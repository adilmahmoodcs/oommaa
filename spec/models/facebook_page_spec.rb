require 'rails_helper'

RSpec.describe FacebookPage, type: :model do
  let(:facebook_page) { create(:facebook_page) }

  it "starts posts import after creation" do
    facebook_page.run_callbacks(:commit)
    expect(PostsImporterJob).to have_been_enqueued.with(facebook_page)
  end

  it "do not start again after an update" do
    facebook_page.run_callbacks(:commit)
    facebook_page.update_attribute(:name, "some name")
    facebook_page.run_callbacks(:commit)
    expect(PostsImporterJob).to have_been_enqueued.with(facebook_page)
  end
end
