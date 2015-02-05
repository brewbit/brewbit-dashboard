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
# * temp_profile_completion_action [integer] - - What to do after the temp profile is finished
#
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time

class DeviceSession < ActiveRecord::Base
  SETPOINT_TYPE = { static: 0, temp_profile: 1 }
  COMPLETION_ACTION = { hold_last: 0, start_over: 1 }

  audited except: [ :last_reading, :last_setpoint ]
  has_associated_audits

  belongs_to :device, touch: true
  belongs_to :temp_profile

  has_many :output_settings, class_name: 'OutputSettings', dependent: :destroy, foreign_key: 'device_session_id'

  validate :output_available

  validates :device, presence: true
  validates :active, inclusion: [true, false]
  validates :name, presence: true, length: { maximum: 100 }
  validates :sensor_index, presence: true
  validates :setpoint_type, presence: true, inclusion: { in: SETPOINT_TYPE.values }
  validates :static_setpoint, presence: true, if: "setpoint_type == SETPOINT_TYPE[:static]"
  validates :temp_profile, presence: true, if: "setpoint_type == SETPOINT_TYPE[:temp_profile]"
  validates :temp_profile_completion_action, presence: true, inclusion: { in: COMPLETION_ACTION.values }
  validates :temp_profile_start_point, presence: true
  validates :access_token, presence: true

  accepts_nested_attributes_for :output_settings, allow_destroy: true

  before_validation :generate_access_token
  before_create :generate_uuid
  after_create :create_readings_file

  # virtual attribute to receive transient "start point" field from new/edit session form
  attr_accessor :temp_profile_start_point

  after_initialize do |session|
    @temp_profile_start_point = 0
  end

  def static_setpoint(scale = nil)
    scale ||= device.try( :user ).try( :temperature_scale )

    if scale == 'C'
      fahrenheit_to_celsius( read_attribute(:static_setpoint) )
    else
      read_attribute( :static_setpoint )
    end
  end

  def static_setpoint=(value)
    scale = device.try( :user ).try( :temperature_scale )

    if scale == 'C'
      write_attribute( :static_setpoint, celsius_to_fahrenheit(value) )
    else
      write_attribute( :static_setpoint, value )
    end
  end
  
  def last_reading
    scale = device.try( :user ).try( :temperature_scale )

    reading = read_attribute(:last_reading)
    if !reading.nil? && scale == 'C'
      reading = fahrenheit_to_celsius( reading )
    end
    reading
  end
  
  def last_setpoint
    scale = device.try( :user ).try( :temperature_scale )

    sp = read_attribute( :last_setpoint )
    if !sp.nil? && scale == 'C'
      sp = fahrenheit_to_celsius( sp )
    end
    sp
  end

  private

  def fahrenheit_to_celsius(degrees)
    (degrees.to_f - 32) / 1.8
  end

  def celsius_to_fahrenheit(degrees)
    degrees.to_f * 1.8 + 32
  end

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
  
  def generate_access_token
    if self.access_token.nil?
      begin
        self.access_token = SecureRandom.hex
      end while self.class.exists?(access_token: access_token)
    end
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
    used_outputs = session_outputs[other_output] || []

    self.output_settings.each do |output|
      if used_outputs.include?( output.output_index )
        errors.add( :output_settings, "#{output.index_name} Output is being used by the other controller" )
      end
    end
  end
end
