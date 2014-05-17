class RemoveActivationTokens < ActiveRecord::Migration
  def up
    drop_table :activation_tokens
  end

  def down
    create_table :activation_tokens do |t|
      t.string :token
      t.string :device
      t.integer :user_id

      t.timestamps
    end

    add_index :activation_tokens, :token, unique: true
    add_index :activation_tokens, :user_id
  end
end
