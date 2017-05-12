class AddCeaseAndDesistTemplateToLicensor < ActiveRecord::Migration[5.0]
  def change
    create_table :cease_and_desist_templates do |t|
      t.string :text, null: false
      t.references :licensor, foreign_key: true

      t.timestamps
    end
  end
end
