class AddShutDownByFacebookAtToFacebookPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :facebook_posts, :shut_down_by_facebook_at, :datetime
  end
end
