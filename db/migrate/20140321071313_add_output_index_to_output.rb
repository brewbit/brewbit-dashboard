class AddOutputIndexToOutput < ActiveRecord::Migration
  def change
    add_column :outputs, :output_index, :integer
    add_index :outputs, :output_index
  end
end
