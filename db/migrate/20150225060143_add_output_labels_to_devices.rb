class AddOutputLabelsToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :output_1_name, :string, default: "Left Output"
    add_column :devices, :output_2_name, :string, default: "Right Output"
    add_column :devices, :sensor_1_name, :string, default: "Sensor 1"
    add_column :devices, :sensor_2_name, :string, default: "Sensor 2"
  end
end
