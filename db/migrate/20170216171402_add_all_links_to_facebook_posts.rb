class AddAllLinksToFacebookPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :facebook_posts, :all_links, :string, array: true, default: []
    add_index :facebook_posts, :all_links, using: 'gin'
  end
end
