class ReferenceSensorFromOutputSettings < ActiveRecord::Migration
  def change
    add_column :output_settings, :sensor_id, :integer
    remove_column :output_settings, :sensor_settings_id, :integer
  end
end
