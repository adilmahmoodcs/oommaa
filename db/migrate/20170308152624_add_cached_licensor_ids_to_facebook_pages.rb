class AddCachedLicensorIdsToFacebookPages < ActiveRecord::Migration[5.0]
  def change
    add_column :facebook_pages, :cached_licensor_ids, :integer, array: true, default: []
    add_index :facebook_pages, :cached_licensor_ids, using: 'gin'
  end
end
