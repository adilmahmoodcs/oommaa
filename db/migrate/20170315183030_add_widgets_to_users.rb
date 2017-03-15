class AddWidgetsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :widgets, :string, array: true, default: []
    add_index :users, :widgets, using: 'gin'
  end
end
