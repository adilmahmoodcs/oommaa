class AddCeaseAndDesistTemplateToLicensor < ActiveRecord::Migration[5.0]
  def change
    add_column :licensors, :cease_and_desist_template, :string
    add_column :licensors, :cease_and_desist_subject, :string
  end
end
