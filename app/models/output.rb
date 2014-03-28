# Attributes:
# * device_id [integer] - - belongs to :device
# * output_index [integer] - - Index of the output, from left and start at 0
#
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time
class Output < ActiveRecord::Base
  belongs_to :device
  belongs_to :sensor
  has_many :settings, -> { order 'created_at ASC' }, class_name: 'OutputSettings'

  validates :output_index, allow_blank: true, numericality: { only_integer: true, greater_than: -1 }
  
  def current_settings
    device.current_command.output_settings.find_by output: self
  end
end

