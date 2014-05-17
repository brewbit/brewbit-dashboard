class CreateTemperatureProfiles < ActiveRecord::Migration
  def change
    create_table :temperature_profiles do |t|
      t.string :name
      t.references :user
      t.references :brew

      t.timestamps
    end
    add_index :temperature_profiles, :user_id
    add_index :temperature_profiles, :brew_id
  end
end
