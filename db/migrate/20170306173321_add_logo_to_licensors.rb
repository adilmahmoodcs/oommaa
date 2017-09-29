class AddLogoToLicensors < ActiveRecord::Migration[5.0]
  def up
    add_attachment :licensors, :logo
  end

  def down
    remove_attachment :licensors, :logo
  end
end
