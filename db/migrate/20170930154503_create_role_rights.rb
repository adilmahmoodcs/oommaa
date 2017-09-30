class CreateRoleRights < ActiveRecord::Migration[5.0]
  def change
    create_table :role_rights do |t|
      t.references :role, foreign_key: true
      t.references :right, foreign_key: true

      t.timestamps
    end
  end
end
