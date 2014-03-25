class AddDeviceCommand < ActiveRecord::Migration
  def change
    create_table :device_commands do |t|
      t.integer :device_id
      t.string  :name
      t.timestamps
    end
    
    create_table :sensor_settings do |t|
      t.integer :device_command_id
      t.index   :device_command_id
      t.integer :sensor_id
      t.index   :sensor_id
      t.integer :setpoint_type
      t.float   :static_setpoint
      t.integer :temp_profile_id
      t.timestamps
    end
    
    create_table :output_settings do |t|
      t.integer :device_command_id
      t.index   :device_command_id
      t.integer :output_id
      t.index   :output_id
      t.integer :function
      t.integer :sensor_settings_id
      t.index   :sensor_settings_id
      t.integer :cycle_delay
      t.integer :output_mode
      t.timestamps
    end
    
    remove_column :sensors, :setpoint_type, :integer
    remove_column :sensors, :static_setpoint, :float
    remove_column :sensors, :temp_profile_id, :integer
    
    remove_column :outputs, :function, :string
    remove_column :outputs, :sensor_id, :integer
    remove_column :outputs, :cycle_delay, :integer
    remove_column :outputs, :output_mode, :integer
  end
end
