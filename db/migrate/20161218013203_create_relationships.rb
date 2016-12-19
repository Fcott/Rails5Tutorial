class CreateRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :relationships do |t|
      t.integer :folloer_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :relationships, :folloer_id
    add_index :relationships, :followed_id
    add_index :relationships, [:folloer_id, :followed_id], unique: true
  end
end
