class CreatePostBrands < ActiveRecord::Migration[5.0]
  def change
    create_table :post_brands do |t|
      t.belongs_to :facebook_post, index: true
      t.belongs_to :brand, index: true
      t.timestamps
    end
  end
end
