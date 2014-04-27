# == Schema Information
#
# Table name: devices
#
# Attributes:
# * activation_token [string] - - Activation token to be used for this device
# * hardware_identifier [string] - - Hardware ID to be used for API calls
# * name [string] - - Device name
# * user_id [integer] - - belongs to :user
# * output_count [integer] - - number of outputs that this device has
# * sensor_count [integer] - - number of sensors that this device has
# * control_mode [integer] - - PID or ON/OFF control mode
# * hysteresis [float] -- Hysteresis for use with outputs when in ON/OFF mode
#
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time

class Device < ActiveRecord::Base
  CONTROL_MODE = { on_off: 0, pid: 1 }
  MAX_HYSTERESIS = 10

  belongs_to :user, class_name: "Spree::User"

  has_many :sessions, class_name: 'DeviceSession', dependent: :destroy, foreign_key: 'device_id'

  validates :name, presence: true, length: { maximum: 100 }
  validates :control_mode, presence: true, inclusion: CONTROL_MODE.values
  validates :hardware_identifier, uniqueness: { case_sensitive: true }
  validates :hysteresis, presence: true,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: MAX_HYSTERESIS }

  def active_sessions
    sessions.order(sensor_index: :asc).where(active: true)
  end

  def active_session_for(sensor_index)
    sessions.find_by active: true, sensor_index: sensor_index
  end

  def active_session_output_info
    info = {}

    active_sessions.each do |session|
      info[session.sensor_index] = []
      session.output_settings.each do |output|
        info[session.sensor_index] << output.output_index
      end
    end

    info
  end

  def activated?
    !user.blank?
  end

  def hysteresis
    scale = self.try( :user ).try( :temperature_scale )

    val = read_attribute( :hysteresis )
    if scale == 'C'
      val = f_to_c_scale( val )
    else
      val
    end
  end

  def hysteresis=(val)
    scale = self.try( :user ).try( :temperature_scale )

    value = val
    if scale == 'C'
      value = c_to_f_scale(value)
    end

    write_attribute( :hysteresis, value )
  end

  private

  def f_to_c_scale(degrees)
    degrees / 1.8
  end

  def c_to_f_scale(degrees)
    degrees.to_f * 1.8
  end
end
