class AddBrandsToFacebookPages < ActiveRecord::Migration[5.0]
  def change
    add_column :facebook_pages, :brand_ids, :integer, array: true, default: []
    add_index :facebook_pages, :brand_ids, using: 'gin'
  end
end
