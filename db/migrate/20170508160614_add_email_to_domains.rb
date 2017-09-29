class AddEmailToDomains < ActiveRecord::Migration[5.0]
  def change
    add_column :domains, :owner_email, :string
  end
end
