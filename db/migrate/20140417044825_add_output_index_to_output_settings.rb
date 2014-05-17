class AddOutputIndexToOutputSettings < ActiveRecord::Migration
  def change
    add_column :output_settings, :output_index, :integer
  end
end
