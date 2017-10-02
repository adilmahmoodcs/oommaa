class CreateCertificates < ActiveRecord::Migration[5.0]
  def change
    create_table :certificates do |t|
      t.references :employee, foreign_key: true
      t.string :name
      t.string :provider
      t.boolean :confirmation
      t.datetime :completion_date
      t.text :notes

      t.timestamps
    end
  end
end
