class AddRoleToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :role, :integer, null: false, default: 0
    User.update_all(role: 2) # admin
  end

  def down
    remove_column :users, :role
  end
end
