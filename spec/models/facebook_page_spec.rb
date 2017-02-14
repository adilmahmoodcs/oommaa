require 'rails_helper'

RSpec.describe FacebookPage, type: :model do
  let(:facebook_page) { create(:facebook_page) }

  it "starts posts import after creation" do
    facebook_page.run_callbacks(:commit)
    expect(PostsImporterJob).to have_been_enqueued.with(facebook_page.facebook_id)
  end

  it "do not start import after update" do
    facebook_page.run_callbacks(:commit) # after create
    facebook_page.update_attribute(:name, "some name")
    facebook_page.run_callbacks(:commit)
    expect(PostsImporterJob).to_not have_been_enqueued.with(facebook_page.facebook_id)
  end
end
