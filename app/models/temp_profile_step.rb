# Attributes:
# * duration [integer] - Duration of step (in seconds)
# * duration_type [string] - Type of the duration, e.g. day, minute, hour, etc.
# * step_index [integer] - Index of step in the temp profile
# * value [float] - Setpoint value for step
# * step_type [integer] - Hold or ramp to the setpoint value
# * temp_profile_id [integer] - Temp profile to which this step belongs
#
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time
class TempProfileStep < ActiveRecord::Base

  belongs_to :temp_profile

  STEP_TYPE = { hold: 0, ramp: 1 }
  DURATION_TYPE = %w( minutes hours days weeks )

  validates :duration, presence: true, numericality: true
  validates :step_index, presence: true, numericality: true
  validates :value, presence: true, numericality: true
  validates :duration_type, presence: true, inclusion: { in: DURATION_TYPE }
  validates :step_type, presence: true, inclusion: { in: STEP_TYPE.values }

  def as_json( options = {} )
    super( options.merge(
      except: [ :id, :created_at, :updated_at, :temp_profile_id ]
    ))
  end

  def duration_for_device
    multiplier = 1

    case self.duration_type
    when 'minutes'
      multiplier = 60
    when 'hours'
      multiplier = 60 * 60
    when 'days'
      multiplier = 60 * 60 * 24
    when 'weeks'
      multiplier = 60 * 60 * 24 * 7
    end

    self.duration * multiplier
  end
end
