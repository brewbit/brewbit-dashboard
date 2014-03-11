class RemoveDeviceFromBrewData < ActiveRecord::Migration
  def up
    remove_column :brew_data_points, :device_id
  end

  def down
    add_column :brew_data_points, :device_id, :integer
    add_index :brew_data_points, :device_id
  end
end
