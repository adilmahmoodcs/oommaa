class AddLicensorToBrands < ActiveRecord::Migration[5.0]
  def change
    add_reference :brands, :licensor, foreign_key: true
  end
end
