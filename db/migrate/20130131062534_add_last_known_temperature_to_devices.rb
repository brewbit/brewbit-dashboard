class AddLastKnownTemperatureToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :last_known_temperature, :decimal
  end
end
