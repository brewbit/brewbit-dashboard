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
#
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time

class Device < ActiveRecord::Base
  CONTROL_MODE = { on_off: 0, pid: 1 }
  
  belongs_to :user, class_name: "Spree::User"

  has_many :sessions, class_name: 'DeviceSession', dependent: :destroy, foreign_key: 'device_id'

  validates :name, presence: true, length: { maximum: 100 }
  validates :control_mode, presence: true, inclusion: CONTROL_MODE.values
  validates :hardware_identifier, uniqueness: { case_sensitive: true }

  def active_sessions
    sessions.order(sensor_index: :asc).where(active: true)
  end

  def active_session_for(sensor_index)
    sessions.find_by active: true, sensor_index: sensor_index
  end

  def activated?
    !user.blank?
  end
end
