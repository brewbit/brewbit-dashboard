class ReaddActivationTokenToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :activation_token, :string
    add_index :devices, :activation_token
  end
end
