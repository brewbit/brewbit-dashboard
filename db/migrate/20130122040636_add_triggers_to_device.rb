class AddTriggersToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :upper_trigger, :decimal
    add_column :devices, :lower_trigger, :decimal
  end
end
