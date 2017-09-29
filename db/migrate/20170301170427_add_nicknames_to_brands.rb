class AddNicknamesToBrands < ActiveRecord::Migration[5.0]
  def change
    add_column :brands, :nicknames, :string, array: true, default: []
    add_index :brands, :nicknames, using: 'gin'
  end
end
