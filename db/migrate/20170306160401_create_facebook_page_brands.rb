class CreateFacebookPageBrands < ActiveRecord::Migration[5.0]
  def change
    create_table :facebook_page_brands do |t|
      t.references :facebook_page, foreign_key: true
      t.references :brand, foreign_key: true

      t.timestamps
    end
  end
end
