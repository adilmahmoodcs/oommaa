require 'rails_helper'

RSpec.describe FacebookPage, type: :model do
  let(:facebook_page) { create(:facebook_page) }

  it "starts posts import after creation" do
    expect { facebook_page }.to(change(PostsImporterJob.jobs, :size).by(1))
  end

  it "do not start again after an update" do
    facebook_page
    expect {
      facebook_page.touch
    }.to_not(
      change(PostsImporterJob.jobs, :size)
    )
  end
end
