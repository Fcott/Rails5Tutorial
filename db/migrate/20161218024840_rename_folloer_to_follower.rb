class RenameFolloerToFollower < ActiveRecord::Migration[5.0]
  def change
    rename_column :relationships, :folloer_id, :follower_id
    # rename_index :relationships, :folloer_id, :follower_id
    # rename_index :relationships, [:folloer_id, :followed_id], [:follower_id, :followed_id]
  end
end
