class AddTypeToScreenshots < ActiveRecord::Migration[5.0]
  def change
    add_column :screenshots, :type, :string
  end
end
