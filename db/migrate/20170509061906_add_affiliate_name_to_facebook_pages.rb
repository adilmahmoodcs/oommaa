class AddAffiliateNameToFacebookPages < ActiveRecord::Migration[5.0]
  def change
    add_column :facebook_pages, :affiliate_name, :string
  end
end
