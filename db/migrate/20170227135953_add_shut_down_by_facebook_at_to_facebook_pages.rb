class AddShutDownByFacebookAtToFacebookPages < ActiveRecord::Migration[5.0]
  def change
    add_column :facebook_pages, :shut_down_by_facebook_at, :datetime
  end
end
