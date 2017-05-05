class AddShutdownQueueTo < ActiveRecord::Migration[5.0]
  def change
    add_column :facebook_posts, :shutdown_queue_at, :datetime, after: :blacklisted_by
    add_column :facebook_posts, :shutdown_queue_by, :string, after: :greylisted_at
  end
end
