class RenameProbesToSensors < ActiveRecord::Migration
  def change
    rename_column :outputs, :probe_id, :sensor_id
    rename_column :probes, :probe_type, :sensor_type
    rename_column :sensor_readings, :probe_id, :sensor_id
    
    rename_table :probes, :sensors
  end
end
