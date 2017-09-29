class AddRelationForUserAndDomains < ActiveRecord::Migration[5.0]
  def change
    create_table :assigned_domains do |t|
      t.belongs_to :user, index: true
      t.belongs_to :domain, index: true
      t.timestamps
    end
  end
end
