class AddSetpointFieldsToSensor < ActiveRecord::Migration
  def change
    add_column :sensors, :setpoint_type, :integer
    add_column :sensors, :static_setpoint, :float
    add_column :sensors, :dynamic_setpoint_id, :integer
  end
end
