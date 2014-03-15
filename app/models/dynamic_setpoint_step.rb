# Attributes:
# * point_index [integer] - TODO: document me
# * start_day [decimal] - TODO: document me
# * start_hour [decimal] - TODO: document me
# * start_minute [decimal] - TODO: document me
# * temperature [decimal] - TODO: document me
# * dynamic_setpoint_id [integer] - belongs to :dynamic_setpoint
# * dynamic_setpoint_point_id [integer] - TODO: document me
# * temperature_scale [string] - TODO: document me
# * time_offset [integer] - TODO: document me
# * transition_type [string] - TODO: document me
#
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time
class DynamicSetpointStep < ActiveRecord::Base

  belongs_to :dynamic_setpoint

  validates :time_offset, presence: true, numericality: true
  validates :point_index, presence: true, numericality: true
  validates :temperature, presence: true, numericality: true
  validates :transition_type, presence: true, inclusion: { in: [ 'gradual', 'crash' ] }

  def as_json( options = {} )
    super( options.merge(
      except: [ :id, :created_at, :updated_at, :dynamic_setpoint_id ]
    ))
  end
end
