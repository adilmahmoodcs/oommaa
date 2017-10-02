class CreateEmployeeProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :employee_projects do |t|
      t.references :employee, foreign_key: true
      t.integer :project_id
      t.string :name
      t.datetime :issue
      t.datetime :finish
      t.datetime :completed
      t.text :notes

      t.timestamps
    end
  end
end
