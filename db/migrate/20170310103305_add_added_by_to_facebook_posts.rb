class AddAddedByToFacebookPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :facebook_posts, :added_by, :string
  end
end
