class CreateLaborCardDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :labor_card_details do |t|
      t.references :employee, foreign_key: true
      t.string :labor_card_id
      t.string :name
      t.datetime :issue
      t.datetime :finish
      t.datetime :completed
      t.text :notes

      t.timestamps
    end
  end
end
