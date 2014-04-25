require 'fileutils'

# == Schema Information
#
# Table name: device_sessions
#
# Attributes:
# * name [string] - - Device name
# * device_id [integer] - - belongs to :device
# * sensor_index [integer] - - Which sensor it belongs to
# * setpoint_type [integer] - - Static setpoint or temp profile
# * static_setpoint [float] - - The static setpoint value
# * temp_profile_id [integer] - - The active temp profile
#
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time

class DeviceSession < ActiveRecord::Base
  SETPOINT_TYPE = { static: 0, temp_profile: 1 }

  belongs_to :device
  belongs_to :temp_profile

  has_many :output_settings, class_name: 'OutputSettings', dependent: :destroy, foreign_key: 'device_session_id'

  validate :output_available

  validates :device, presence: true
  validates :active, inclusion: [true, false]
  validates :uuid, presence: true
  validates :name, presence: true, length: { maximum: 100 }
  validates :sensor_index, presence: true
  validates :setpoint_type, presence: true, inclusion: { in: SETPOINT_TYPE.values }
  validates :static_setpoint, presence: true, if: "setpoint_type == SETPOINT_TYPE[:static]"
  validates :temp_profile, presence: true, if: "setpoint_type == SETPOINT_TYPE[:temp_profile]"

  accepts_nested_attributes_for :output_settings

  before_validation :generate_uuid
  after_create :create_readings_file

  def static_setpoint(scale = 'F')
    if scale == 'C'
      fahrenheit_to_celcius( read_attribute(:static_setpoint) )
    else
      read_attribute( :static_setpoint )
    end
  end

  def static_setpoint=(value)
    scale = device.try( :user ).try( :temperature_scale )

    if scale == 'C'
      write_attribute( :static_setpoint, fahrenheit_to_celcius(value) )
    else
      write_attribute( :static_setpoint, value )
    end
  end

  private

  def fahrenheit_to_celcius(degrees)
    (degrees.to_f - 32) / 1.8
  end

  def celcius_to_fahrenheit(degrees)
    degrees.to_f * 1.8 + 32
  end

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end

  def create_readings_file
    # even though the first append would create the file, we want
    # it to be present so that the user does not get a 404 for this
    # file when they load the show action
    FileUtils.touch("public/readings/#{self.uuid}.csv")
  end

  def output_available
    session_outputs = self.device.active_session_output_info
    other_output = (self.sensor_index == 0 ? 1 : 0)
    used_outputs = session_outputs[other_output]

    self.output_settings.each do |output|
      if used_outputs.include?( output.output_index )
        errors.add( :output_settings, "#{output.index_name} Output is being used by the other controller" )
      end
    end
  end
end
