class RemoveOldLogoFromBrands < ActiveRecord::Migration[5.0]
  def up
    remove_attachment :brands, :logo
  end
end
