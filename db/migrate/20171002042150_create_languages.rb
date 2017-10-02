class CreateLanguages < ActiveRecord::Migration[5.0]
  def change
    create_table :languages do |t|
      t.references :employee, foreign_key: true
      t.string :name
      t.string :written_level
      t.string :speaking_level
      t.boolean :native_language
      t.text :notes
      t.boolean :confirmation

      t.timestamps
    end
  end
end
