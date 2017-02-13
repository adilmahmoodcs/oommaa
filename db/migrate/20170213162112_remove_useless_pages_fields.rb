class RemoveUselessPagesFields < ActiveRecord::Migration[5.0]
  def change
    remove_column :facebook_pages, :url
    remove_column :facebook_pages, :description
    remove_column :facebook_pages, :image_url
  end
end
