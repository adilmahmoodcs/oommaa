class RemoveStatusChangedAt < ActiveRecord::Migration[5.0]
  def change
    remove_column :facebook_posts, :status_changed_at
  end
end
