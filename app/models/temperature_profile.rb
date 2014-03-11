# Attributes:
# * id [integer, primary, not null] - primary key
# * brew_id [integer] - belongs to :brew
# * created_at [datetime, not null] - creation time
# * name [string]
# * updated_at [datetime, not null] - last update time
# * user_id [integer] - belongs to :user
class TemperatureProfile < ActiveRecord::Base
  belongs_to :user

  has_many :brews
  has_many :temperature_points, -> { order('point_index ASC') }

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 100 }
end
