# Attributes:
# * device_id [integer] - - belongs to :device
# * function [string] - - Function of the output [ HOT, COLD ]
# * output_index [integer] - - Index of the output, from left and start at 0
# * cycle_delay [integer] - - How much to wait between power cycles of an output in minutes
# * output_mode [integer] - - Output control mode [PID, ON_OFF]
#
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time
class Output < ActiveRecord::Base
  belongs_to :device
  belongs_to :sensor

  OUTPUT_MODE = { on_off: 0, pid: 1 }
  FUNCTIONS = { hot: 'hot', cold: 'cold' }
  INDEX_NAME = [ 'left', 'right' ]

  MAX_CYCLE_DELAY = 30

  validates :function, presence: true, inclusion: { in: FUNCTIONS.values }
  validates :output_index, allow_blank: true, numericality: { only_integer: true, greater_than: -1 }
  validates :sensor_id,
            allow_blank: true,
            inclusion: { in: lambda { |output| output.device.sensors.map { |o| o.id } },
                                      message: 'Only devices sensors are allowed' }
  validates :cycle_delay, allow_blank: true,
            numericality: { only_integer: true,
                            greater_than: 0,
                            less_than_or_equal_to: MAX_CYCLE_DELAY }
end

