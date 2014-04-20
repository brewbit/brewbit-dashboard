class AddHysteresisToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :hysteresis, :float
  end
end
