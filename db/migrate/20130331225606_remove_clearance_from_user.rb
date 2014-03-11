class RemoveClearanceFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :encrypted_password
    remove_column :users, :confirmation_token
    remove_column :users, :remember_token
  end

  def down
    add_column :users, :encrypted_password, :string, limit: 128, null: false
    add_column :users, :confirmation_token, :string, limit: 128
    add_column :users, :remember_token, :string, limit: 128, null: false

    add_index :users, :remember_token
  end
end
