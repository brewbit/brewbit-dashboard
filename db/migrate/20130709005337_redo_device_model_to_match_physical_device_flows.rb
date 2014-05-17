class RedoDeviceModelToMatchPhysicalDeviceFlows < ActiveRecord::Migration
  def up
    change_table :devices, bulk: true do |t|
      t.remove :display_units
      t.remove :last_known_temperature
      t.remove :upper_trigger
      t.remove :lower_trigger

      t.rename :right_output, :right_output_function
      t.string :right_output_state

      t.rename :left_output, :left_output_function
      t.string :left_output_state
    end
  end

  def down
    change_table :devices, bulkd: true do |t|
      t.remove :left_output_state
      t.rename :left_output_function, :left_output

      t.remove :right_output_state
      t.rename :right_output_function, :right_output

      t.string :lower_trigger
      t.string :upper_trigger
      t.decimal :last_known_temperature
      t.string :display_units
    end
  end
end
