class AddUpdateChannelToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :update_channel, :string, default: 'stable'
  end
end
