class CreateEmailTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :email_templates do |t|
      t.string :text, null: false
      t.references :parent, polymorphic: true, index: true

      t.timestamps
    end
  end
end
