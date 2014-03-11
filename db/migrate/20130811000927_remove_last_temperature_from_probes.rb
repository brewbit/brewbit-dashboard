class RemoveLastTemperatureFromProbes < ActiveRecord::Migration
  def up
    remove_column :probes, :last_temperature
  end

  def down
    add_column :probes, :last_temperature, :decimal
  end
end
