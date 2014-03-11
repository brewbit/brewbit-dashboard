class DeviceConnection < ActiveRecord::Base
  validates :socket_id, presence: true, uniqueness: true
  validates :device_id, uniqueness: true, allow_nil: true
end

