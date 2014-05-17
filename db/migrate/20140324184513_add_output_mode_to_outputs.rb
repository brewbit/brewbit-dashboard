class AddOutputModeToOutputs < ActiveRecord::Migration
  def change
    add_column :outputs, :output_mode, :integer
  end
end
