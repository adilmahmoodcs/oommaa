class AddStatusToFacebookPages < ActiveRecord::Migration[5.0]
  def change
    add_column :facebook_pages, :status, :integer, default: 0
  end
end
