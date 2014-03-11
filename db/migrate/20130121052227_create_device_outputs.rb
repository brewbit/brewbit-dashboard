class CreateDeviceOutputs < ActiveRecord::Migration
  def change
    create_table :device_outputs do |t|
      t.string :role
      t.boolean :enabled
      t.references :device

      t.timestamps
    end

    add_index :device_outputs, :device_id
  end
end
