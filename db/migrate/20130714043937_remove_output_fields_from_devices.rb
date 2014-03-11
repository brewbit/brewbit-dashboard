class RemoveOutputFieldsFromDevices < ActiveRecord::Migration
  def up
    change_table :devices, bulk: true do |t|
      t.remove :left_output_function
      t.remove :left_output_state
      t.remove :right_output_function
      t.remove :right_output_state
    end
  end

  def down
    change_table :devices, bulk: true do |t|
      t.string :right_output_state
      t.string :right_output_function
      t.string :left_output_state
      t.string :left_output_function
    end
  end
end
