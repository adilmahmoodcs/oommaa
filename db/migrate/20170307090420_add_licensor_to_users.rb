class AddLicensorToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :licensor, foreign_key: true
  end
end
