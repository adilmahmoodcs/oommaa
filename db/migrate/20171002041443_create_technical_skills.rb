class CreateTechnicalSkills < ActiveRecord::Migration[5.0]
  def change
    create_table :technical_skills do |t|
      t.references :employee, foreign_key: true
      t.string :level
      t.integer :level_id
      t.boolean :confirmation
      t.string :name
      t.text :notes

      t.timestamps
    end
  end
end
