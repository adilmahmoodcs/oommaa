class CreateFacebookPages < ActiveRecord::Migration[5.0]
  def change
    create_table :facebook_pages do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.text :description
      t.string :image_url
      t.string :facebook_id, null: false

      t.timestamps
    end
  end
end
