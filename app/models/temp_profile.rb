# Attributes:
# * id [integer, primary, not null] - primary key
# * brew_id [integer] - belongs to :brew
# * created_at [datetime, not null] - creation time
# * name [string]
# * updated_at [datetime, not null] - last update time
# * user_id [integer] - belongs to :user
class TempProfile < ActiveRecord::Base
  belongs_to :user, class_name: 'Spree::User'

  has_many :steps, -> { order('step_index ASC') }, class_name: 'TempProfileStep', foreign_key: 'temp_profile_id', dependent: :destroy
  accepts_nested_attributes_for :steps, allow_destroy: true

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 100 }
  
  def start_value
    scale = self.try( :user ).try( :temperature_scale )

    case scale
    when 'F'
      read_attribute( :start_value )
    when 'C'
      fahrenheit_to_celcius( read_attribute(:start_value) )
    else
      read_attribute( :start_value )
    end
  end

  def start_value=(val)
    scale = self.try( :user ).try( :temperature_scale )

    case scale
    when 'F'
      write_attribute( :start_value, val )
    when 'C'
      write_attribute( :start_value, celcius_to_fahrenheit(val) )
    else
      write_attribute( :start_value, val )
    end
  end

  private

  def fahrenheit_to_celcius(degrees)
    (degrees.to_f - 32) / 1.8
  end

  def celcius_to_fahrenheit(degrees)
    degrees.to_f * 1.8 + 32
  end
end
