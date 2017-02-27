require 'rails_helper'

RSpec.describe FacebookPage, type: :model do
  let(:page) { create(:facebook_page) }
  let(:post) { create(:facebook_post, facebook_page: page) }

  describe "mark_as_shut_down!" do
    it "touches #shut_down_by_facebook_at" do
      expect {page.mark_as_shut_down!}.to(
        change {page.shut_down_by_facebook_at}
      )
    end

    it "touches #shut_down_by_facebook_at on all page posts" do
      expect {page.mark_as_shut_down!}.to(
        change {post.reload.shut_down_by_facebook_at}
      )
    end
  end
end
