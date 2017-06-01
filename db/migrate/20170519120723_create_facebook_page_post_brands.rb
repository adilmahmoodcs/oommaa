class CreateFacebookPagePostBrands < ActiveRecord::Migration[5.0]
  def change
    create_table :facebook_page_post_brands do |t|
      t.belongs_to :facebook_post, index: true
      t.belongs_to :facebook_page_brand, index: true
      t.timestamps
    end
  end
end
