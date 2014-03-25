# Attributes:
# * device_command_id [integer] - - Which device command it belongs to
# * output_id [integer] - - Which output it belongs to
# * function [integer] - - Function of the output [ HEATING, COOLING ]
# * cycle_delay [integer] - - How much to wait between power cycles of an output in minutes
# * output_mode [integer] - - Output control mode [PID, ON_OFF]
# * sensor_id [integer] - - Which sensor it is controlled by
#
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time
class OutputSettings < ActiveRecord::Base
  belongs_to :device_command
  belongs_to :output
  belongs_to :sensor_settings

  OUTPUT_MODE = { on_off: 0, pid: 1 }
  FUNCTIONS = { heating: 0, cooling: 1 }
  FUNCTION_NAME = [ 'heating', 'cooling' ]
  INDEX_NAME = [ 'left', 'right' ]

  MAX_CYCLE_DELAY = 30

  validates :function, presence: true, inclusion: { in: FUNCTIONS.values }
#  validates :sensor_settings_id,
#            allow_blank: true,
#            inclusion: { in: lambda { |s| s.device_command.device.sensors.collect { |sensor| sensor.settings.map { |o| o.id } } },
#                                      message: 'Only devices sensor settings are allowed' }
  validates :cycle_delay, allow_blank: true,
            numericality: { only_integer: true,
                            greater_than: 0,
                            less_than_or_equal_to: MAX_CYCLE_DELAY }
end

