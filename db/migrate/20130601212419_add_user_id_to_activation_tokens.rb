class AddUserIdToActivationTokens < ActiveRecord::Migration
  def change
    add_column :activation_tokens, :user_id, :integer
    add_index :activation_tokens, :user_id
  end
end
