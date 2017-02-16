class AddStatusChangedAtToFacebookPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :facebook_posts, :status_changed_at, :datetime
  end
end
