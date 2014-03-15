# Attributes:
# * device_id [integer] - - belongs to :device
# * function [string] - - Function of the output [ HOT, COLD ]
# * output_type [string] - - Left, Right, something else?
# * compressor_delay [integer] - - How much to wait between power cycles for a compressor in minutes
#
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time
class Output < ActiveRecord::Base
  belongs_to :device
  belongs_to :sensor

  FUNCTIONS = { hot: 'hot', cold: 'cold' }
  TYPES = { right: 'right', left: 'left' }

  MAX_COMPRESSOR_DELAY = 10

  validates :function, presence: true, inclusion: { in: FUNCTIONS.values }
  validates :output_type, presence: true, inclusion: { in: TYPES.values }
  validates :sensor_id,
            allow_blank: true,
            inclusion: { in: lambda { |output| output.device.sensors.map { |o| o.id } },
                                      message: 'Only devices sensors are allowed' }
  validates :compressor_delay, allow_blank: true,
            numericality: { only_integer: true,
                            greater_than: 0,
                            less_than_or_equal_to: MAX_COMPRESSOR_DELAY }
end

