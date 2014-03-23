# Attributes:
# * duration [integer] - Duration of step (in seconds)
# * step_index [integer] - Index of step in the dynamic setpoint
# * value [float] - Setpoint value for step
# * step_type [integer] - Hold or ramp to the setpoint value
# * dynamic_setpoint_id [integer] - Dynamic setpoint to which this step belongs
#
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time
class DynamicSetpointStep < ActiveRecord::Base

  belongs_to :dynamic_setpoint

  STEP_TYPE = { hold: 0, ramp: 1 }

  validates :duration, presence: true, numericality: true
  validates :step_index, presence: true, numericality: true
  validates :value, presence: true, numericality: true
  validates :step_type, presence: true, inclusion: { in: STEP_TYPE.values }

  def as_json( options = {} )
    super( options.merge(
      except: [ :id, :created_at, :updated_at, :dynamic_setpoint_id ]
    ))
  end
end
