class AddOutputTypeToOutputs < ActiveRecord::Migration
  def change
    add_column :outputs, :output_type, :string
  end
end
