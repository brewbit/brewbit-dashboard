class AddProbeToBrews < ActiveRecord::Migration
  def change
    add_column :brews, :probe_id, :integer
    add_index :brews, :probe_id
  end
end
