class CreateTrainings < ActiveRecord::Migration[5.0]
  def change
    create_table :trainings do |t|
      t.references :employee, foreign_key: true
      t.string :name
      t.text :location
      t.string :duration
      t.string :provider
      t.boolean :confirmation
      t.datetime :start_date
      t.datetime :end_date
      t.text :notes

      t.timestamps
    end
  end
end
