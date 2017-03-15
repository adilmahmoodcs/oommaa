class CreateUserWidgets < ActiveRecord::Migration[5.0]
  def change
    create_table :user_widgets do |t|
      t.references :user, foreign_key: true
      t.string :widget_name, null: false
      t.integer :position, default: 0

      t.timestamps
    end
  end
end
