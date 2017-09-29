class AddStatusIndexOnFacebookPosts < ActiveRecord::Migration[5.0]
  def change
    add_index :facebook_posts, [:status, :published_at]
  end
end
