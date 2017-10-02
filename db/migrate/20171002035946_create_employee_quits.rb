class CreateEmployeeQuits < ActiveRecord::Migration[5.0]
  def change
    create_table :employee_quits do |t|
      t.references :employee, foreign_key: true
      t.datetime :start_date
      t.datetime :end_date
      t.string :pc
      t.string :phone_no
      t.integer :training_cancel
      t.string :health_insurance

      t.timestamps
    end
  end
end
