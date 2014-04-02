class AddTemperatureScaleToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :temperature_scale, :string
  end
end
