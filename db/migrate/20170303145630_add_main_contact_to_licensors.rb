class AddMainContactToLicensors < ActiveRecord::Migration[5.0]
  def change
    add_column :licensors, :main_contact, :string
  end
end
