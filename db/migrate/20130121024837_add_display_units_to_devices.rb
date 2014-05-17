class AddDisplayUnitsToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :display_units, :string
  end
end
