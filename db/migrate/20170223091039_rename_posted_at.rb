class RenamePostedAt < ActiveRecord::Migration[5.0]
  def change
    rename_column :facebook_posts, :posted_at, :published_at
  end
end
