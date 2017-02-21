class CreateLicensors < ActiveRecord::Migration[5.0]
  def change
    create_table :licensors do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
