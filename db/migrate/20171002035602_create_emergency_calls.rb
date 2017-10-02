class CreateEmergencyCalls < ActiveRecord::Migration[5.0]
  def change
    create_table :emergency_calls do |t|
      t.references :employee, foreign_key: true
      t.string :surname
      t.string :name
      t.string :relationship
      t.boolean :phone_no

      t.timestamps
    end
  end
end
