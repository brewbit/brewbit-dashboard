class CreateTemperatures < ActiveRecord::Migration
  def change
    create_table :temperatures do |t|
      t.float :value
      t.references :device
      t.references :probe

      t.timestamps
    end

    add_index :temperatures, :device_id
    add_index :temperatures, :probe_id
  end
end
