class RemoveUserWidgets < ActiveRecord::Migration[5.0]
  def change
    drop_table :user_widgets if table_exists? :user_widgets
  end
end
