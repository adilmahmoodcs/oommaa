class CreateBrandLogos < ActiveRecord::Migration[5.0]
  def up
    create_table :brand_logos do |t|
      t.references :brand, foreign_key: true

      t.timestamps
    end

    add_attachment :brand_logos, :image
  end

  def down
    drop_table :brand_logos
  end
end
