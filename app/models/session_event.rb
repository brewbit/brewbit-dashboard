class SessionEvent < ActiveRecord::Base
  belongs_to :device_session, touch: false
end
