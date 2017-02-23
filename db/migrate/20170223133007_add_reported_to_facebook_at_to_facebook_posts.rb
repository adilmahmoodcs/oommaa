class AddReportedToFacebookAtToFacebookPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :facebook_posts, :reported_to_facebook_at, :timestamp
    add_column :facebook_posts, :reported_to_facebook_by, :string
  end
end
