class AddDeviceToBrew < ActiveRecord::Migration
  def change
    add_column :brews, :device_id, :integer
    add_index :brews, :device_id
  end
end
