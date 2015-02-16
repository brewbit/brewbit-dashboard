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

  belongs_to :device, touch: true
  belongs_to :temp_profile

  has_many :output_settings, class_name: 'OutputSettings', dependent: :destroy, foreign_key: 'device_session_id'
  has_many :session_events, dependent: :destroy, foreign_key: 'device_session_id'

  validate :output_available

  validates :device, presence: true
  validates :active, inclusion: [true, false]
  validates :name, presence: true, length: { maximum: 100 }
  validates :sensor_index, presence: true
  validates :setpoint_type, presence: true, inclusion: { in: SETPOINT_TYPE.values }
  validates :static_setpoint, presence: true, if: "setpoint_type == SETPOINT_TYPE[:static]"
  validates :temp_profile, presence: true, if: "setpoint_type == SETPOINT_TYPE[:temp_profile]"
  validates :temp_profile_completion_action, presence: true, inclusion: { in: COMPLETION_ACTION.values }, if: "setpoint_type == SETPOINT_TYPE[:temp_profile]" 
  validates :access_token, presence: true
  validates :high_temp_threshold, numericality: { greater_than: 0, allow_nil: true }
  validates :low_temp_threshold, numericality: { greater_than: 0, allow_nil: true }
  validates :comms_loss_threshold, numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_nil: true }

  accepts_nested_attributes_for :output_settings, allow_destroy: true

  before_validation :generate_access_token
  before_create :generate_uuid
  before_create :generate_create_event
  before_update :generate_update_event
  after_create :create_readings_file

  # virtual attribute to receive transient "start point" field from new/edit session form
  attr_accessor :temp_profile_start_point

  after_initialize do |session|
    @temp_profile_start_point = nil
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
  
  def generate_create_event
    event_data = { setpoint_type: self.setpoint_type, output_settings: [] }
    case self.setpoint_type
    when DeviceSession::SETPOINT_TYPE[:static]
      event_data[:static_setpoint] = self.static_setpoint
    when DeviceSession::SETPOINT_TYPE[:temp_profile]
      event_data[:temp_profile_id] = self.temp_profile_id
      event_data[:temp_profile_start_point] = self.temp_profile_start_point
      event_data[:temp_profile_completion_action] = self.temp_profile_completion_action
    end
    event_data[:output_settings] = self.output_settings.map { |os| { output_index: os.output_index, function: os.function, cycle_delay: os.cycle_delay } }
    self.session_events.build(event_type: 'create', event_data: event_data)
  end
  
  def generate_update_event
    event_data = { }
    if self.setpoint_type_changed?
      event_data[:setpoint_type] = self.setpoint_type
      
      # if the setpoint type changed, then log all attributes corresponding to
      # that setpoint type
      case self.setpoint_type
      when DeviceSession::SETPOINT_TYPE[:static]
        event_data[:static_setpoint] = self.static_setpoint
      when DeviceSession::SETPOINT_TYPE[:temp_profile]
        event_data[:temp_profile_id] = self.temp_profile_id
        event_data[:temp_profile_start_point] = self.temp_profile_start_point
        event_data[:temp_profile_completion_action] = self.temp_profile_completion_action
      end
    else
      # if the setpoint type is unchanged, only log attributes that changed
      case self.setpoint_type
      when DeviceSession::SETPOINT_TYPE[:static]
        event_data[:static_setpoint] = self.static_setpoint if self.static_setpoint_changed?
      when DeviceSession::SETPOINT_TYPE[:temp_profile]
        event_data[:temp_profile_id] = self.temp_profile_id if self.temp_profile_id_changed?
        event_data[:temp_profile_completion_action] = self.temp_profile_completion_action if self.temp_profile_completion_action_changed?
        event_data[:temp_profile_start_point] = self.temp_profile_start_point if !self.temp_profile_start_point.nil? && self.temp_profile_start_point != -1
      end
    end
    
    self.output_settings.each do |os|
      if os.marked_for_destruction?
        os_event_data = { output_index: os.output_index, action: 'destroy' }
        event_data[:output_settings] = [] if event_data[:output_settings].blank?
        event_data[:output_settings] << os_event_data
      else
        os_event_data = {}
        os_event_data[:function] = os.function if os.function_changed?
        os_event_data[:cycle_delay] = os.cycle_delay if os.cycle_delay_changed?
        unless os_event_data.empty?
          if os.persisted?
            os_event_data[:action] = 'update'
          else
            os_event_data[:action] = 'create'
          end
          os_event_data[:output_index] = os.output_index
          event_data[:output_settings] = [] if event_data[:output_settings].blank?
          event_data[:output_settings] << os_event_data
        end
      end
    end
    
    unless event_data.empty?
      self.session_events.build(event_type: 'update', event_data: event_data)
    end
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
