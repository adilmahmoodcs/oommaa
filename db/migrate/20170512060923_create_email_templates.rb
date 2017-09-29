class CreateEmailTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :email_templates do |t|
      t.string :text
      t.string :default_subject
      t.integer :template_type
      t.references :parent, polymorphic: true, index: true

      t.timestamps
    end
  end
end
