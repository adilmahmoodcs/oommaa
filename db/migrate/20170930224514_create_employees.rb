class CreateEmployees < ActiveRecord::Migration[5.0]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :surname
      t.string :phone
      t.datetime :dob
      t.references :user, foreign_key: true
      t.integer :manager_id

      t.timestamps
    end
  end
end
