class FormatDynamicSetpointStepFields < ActiveRecord::Migration
  def up
    remove_column :dynamic_setpoint_step, :value
    add_column    :dynamic_setpoint_step, :value, :float
    
    remove_column :dynamic_setpoint_step, :step_type
    add_column    :dynamic_setpoint_step, :step_type, :integer
    
    rename_table :dynamic_setpoint_step, :dynamic_setpoint_steps
  end

  def down
    remove_column :dynamic_setpoint_steps, :value
    add_column    :dynamic_setpoint_steps, :value, :decimal
    
    remove_column :dynamic_setpoint_steps, :step_type
    add_column    :dynamic_setpoint_steps, :step_type, :string
    
    rename_table :dynamic_setpoint_steps, :dynamic_setpoint_step
  end
end
