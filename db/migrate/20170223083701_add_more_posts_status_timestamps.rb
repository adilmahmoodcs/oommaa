class AddMorePostsStatusTimestamps < ActiveRecord::Migration[5.0]
  def change
    add_column :facebook_posts, :whitelisted_at, :datetime
    add_column :facebook_posts, :whitelisted_by, :string
    add_column :facebook_posts, :blacklisted_at, :datetime
    add_column :facebook_posts, :blacklisted_by, :string
  end
end
