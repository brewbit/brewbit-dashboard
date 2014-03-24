class AddStartValueToTempProfile < ActiveRecord::Migration
  def change
    add_column :temp_profiles, :start_value, :float
  end
end
