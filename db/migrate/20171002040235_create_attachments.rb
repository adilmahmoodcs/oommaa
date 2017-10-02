class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|
      t.references :employee, foreign_key: true
      t.string :file
      t.string :notes

      t.timestamps
    end
  end
end
