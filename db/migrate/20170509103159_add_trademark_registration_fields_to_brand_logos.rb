class AddTrademarkRegistrationFieldsToBrandLogos < ActiveRecord::Migration[5.0]
  def change
    add_column :brand_logos, :trademark_registration_number, :string
    add_column :brand_logos, :trademark_registration_location, :string
    add_column :brand_logos, :trademark_registration_category, :string
    add_column :brand_logos, :trademark_registration_url, :string
  end
end
