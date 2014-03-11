class AddOutputsToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :left_output, :string
    add_column :devices, :right_output, :string
  end
end
