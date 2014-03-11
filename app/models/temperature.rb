# Attributes:
# * device_id [integer] - Device that recorded the temperature
# * probe_id [integer]  - Probe that recorded the temperature
# * value [float]       - Temperature
#
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time
class Temperature < ActiveRecord::Base
  belongs_to :device
  belongs_to :probe

  validates :value, presence: true, numericality: true
  validates :device_id, presence: true
  validates :probe_id, presence: true,
            inclusion: { in: lambda { |temp| temp.device.probes.map { |p| p.id } },
                         message: 'Only probes belonging to the device are allowed',
                         unless: Proc.new { |temp| temp.device.blank? } }

  def as_json( options = {} )
    super( options.merge(
      only: [ :value, :created_at ]
    ))
  end
end

