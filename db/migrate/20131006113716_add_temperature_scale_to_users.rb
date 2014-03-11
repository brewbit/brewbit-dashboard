class AddTemperatureScaleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :temperature_scale, :string, default: 'fahrenheit'
  end
end
