class AddProbeTypeToProbes < ActiveRecord::Migration
  def change
    add_column :probes, :probe_type, :string
  end
end
