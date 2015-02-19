class AddFirmwareVersionToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :firmware_version, :string
  end
end
