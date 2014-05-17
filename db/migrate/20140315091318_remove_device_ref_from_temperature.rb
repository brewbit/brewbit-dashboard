class RemoveDeviceRefFromTemperature < ActiveRecord::Migration
  def change
     remove_column :temperatures, :device_id
  end
end
