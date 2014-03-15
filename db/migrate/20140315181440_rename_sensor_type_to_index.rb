class RenameSensorTypeToIndex < ActiveRecord::Migration
  def change
    rename_column :sensors, :sensor_type, :sensor_index
  end
end
