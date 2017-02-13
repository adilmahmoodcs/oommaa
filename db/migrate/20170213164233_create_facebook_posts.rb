class CreateFacebookPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :facebook_posts do |t|
      t.string :facebook_id, null: false
      t.string :message, null: false
      t.datetime :posted_at
      t.string :permalink
      t.string :image_url
      t.integer :status, null: false, default: 0 # enum

      t.timestamps
    end
  end
end
