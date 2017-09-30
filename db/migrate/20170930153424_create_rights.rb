class CreateRights < ActiveRecord::Migration[5.0]
  def change
    create_table :rights do |t|
      t.string :key
      t.string :name
      t.string :category
      t.string :controller
      t.string :actions

      t.timestamps
    end
  end
end
