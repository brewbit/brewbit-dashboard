class RemoveActivationTokenFromDevices < ActiveRecord::Migration
  def up
    remove_column :devices, :activation_token
  end

  def down
    add_column :devices, :activation_token, :string
    add_index :devices, :activation_token
  end
end
