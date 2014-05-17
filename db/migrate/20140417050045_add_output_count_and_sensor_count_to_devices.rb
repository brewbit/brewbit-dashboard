class AddOutputCountAndSensorCountToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :output_count, :integer
    add_column :devices, :sensor_count, :integer
  end
end
