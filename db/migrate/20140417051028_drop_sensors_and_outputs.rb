class DropSensorsAndOutputs < ActiveRecord::Migration
  def change
    drop_table :sensors
    drop_table :outputs
    remove_column :output_settings, :output_id
    remove_column :output_settings, :sensor_id
  end
end
