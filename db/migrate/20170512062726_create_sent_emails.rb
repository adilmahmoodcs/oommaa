class CreateSentEmails < ActiveRecord::Migration[5.0]
  def change
    create_table :sent_emails do |t|
      t.string :subject
      t.string :email
      t.string :cc_emails, array: true, default: []
      t.string :body
      t.integer :brand_id
      t.integer :brand_logo_id
      t.integer :domain_id

      t.references :user, foreign_key: true
      t.references :email_template, foreign_key: true
      t.timestamps
    end
  end
end
