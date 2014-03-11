class ChangeProbeOutputAssociation < ActiveRecord::Migration
  def up
    remove_column :probes, :output_id
    add_column :outputs, :probe_id, :integer
    add_index :outputs, :probe_id
  end

  def down
    add_column :probes, :output_id, :integer
    add_index :probes, :output_id
    remove_column :outputs, :probe_id
  end
end
