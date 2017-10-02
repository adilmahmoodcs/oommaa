class CreatePassportDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :passport_details do |t|
      t.references :employee, foreign_key: true
      t.string :passport_no
      t.string :name
      t.datetime :issue
      t.datetime :finish
      t.datetime :completed
      t.text :notes

      t.timestamps
    end
  end
end
