class CreateEducations < ActiveRecord::Migration[5.0]
  def change
    create_table :educations do |t|
      t.references :employee, foreign_key: true
      t.string :department
      t.string :degree
      t.string :institution
      t.string :thesis
      t.text :notes
      t.string :still_studying
      t.datetime :entrance_date
      t.string :graduation

      t.timestamps
    end
  end
end
