class AddLikesToFacebookPost < ActiveRecord::Migration[5.0]
  def change
    add_column :facebook_posts, :likes, :integer
  end
end
