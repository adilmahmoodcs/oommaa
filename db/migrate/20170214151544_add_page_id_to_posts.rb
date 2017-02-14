class AddPageIdToPosts < ActiveRecord::Migration[5.0]
  def change
    add_reference :facebook_posts, :facebook_page, foreign_key: true
  end
end
