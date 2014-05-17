class RenameDynamicSetpointStepFields < ActiveRecord::Migration
  def change
    rename_column :dynamic_setpoint_step, :time_offset, :duration
    rename_column :dynamic_setpoint_step, :point_index, :index
    rename_column :dynamic_setpoint_step, :temperature, :value
    rename_column :dynamic_setpoint_step, :transition_type, :step_type
  end
end
