class AddAllDomainsToFacebookPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :facebook_posts, :all_domains, :string, array: true, default: []
    add_index :facebook_posts, :all_domains, using: 'gin'
  end
end
