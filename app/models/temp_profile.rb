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

  def steps_graph_data
    graph_data = []

    time_offset = 0
    self.steps.each do |step|
      graph_data.concat( build_step(step, time_offset) )
      time_offset += step.duration_for_device
    end

    graph_data
  end

  private

  def build_step(step, offset)
    if TempProfileStep::STEP_TYPE[:hold] ==  step.step_type
      previous_step = self.steps[step.step_index - 2] # index starts counting at 1, but
      return [[offset, previous_step.value.round(2)],[offset, step.value.round(2)]]
    else
      return [[offset, step.value.round(2)]]
    end
  end

  def fahrenheit_to_celcius(degrees)
    (degrees.to_f - 32) / 1.8
  end

  def celcius_to_fahrenheit(degrees)
    degrees.to_f * 1.8 + 32
  end
end
