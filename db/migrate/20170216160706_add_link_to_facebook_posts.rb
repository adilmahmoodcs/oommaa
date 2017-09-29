class AddLinkToFacebookPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :facebook_posts, :link, :string
  end
end
