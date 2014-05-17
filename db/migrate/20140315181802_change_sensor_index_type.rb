class ChangeSensorIndexType < ActiveRecord::Migration
  def up
    remove_column :sensors, :sensor_index
    add_column :sensors, :sensor_index, :integer
  end

  def down
    remove_column :sensors, :sensor_index
    add_column :sensors, :sensor_index, :string
  end
end
