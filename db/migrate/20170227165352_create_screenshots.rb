class CreateScreenshots < ActiveRecord::Migration[5.0]
  def up
    create_table :screenshots do |t|
      t.references :facebook_post, foreign_key: true

      t.timestamps
    end

    add_attachment :screenshots, :image
  end

  def down
    drop_table :screenshots
    remove_attachment :screenshots, :image
  end
end
