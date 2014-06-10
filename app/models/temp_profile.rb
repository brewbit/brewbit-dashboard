# Attributes:
# * id [integer, primary, not null] - primary key
# * brew_id [integer] - belongs to :brew
# * created_at [datetime, not null] - creation time
# * name [string]
# * updated_at [datetime, not null] - last update time
# * user_id [integer] - belongs to :user
class TempProfile < ActiveRecord::Base
  belongs_to :user, class_name: Brewbit.user_class

  has_many :steps, -> { order('step_index ASC') }, class_name: 'TempProfileStep', foreign_key: 'temp_profile_id', dependent: :destroy
  accepts_nested_attributes_for :steps, allow_destroy: true

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 100 }
  validates :start_value, presence: true
  validates :steps, :length => {
    minimum: 1,
    maximum: 32,
    too_short: "must have at least %{count} step",
    too_long:  "must have at most %{count} steps"
  }

  def start_value(scale = nil)
    scale ||= self.try( :user ).try( :temperature_scale )
    val = read_attribute( :start_value )

    if !val.nil? && scale == 'C'
      val = fahrenheit_to_celsius( val )
    end
    
    val.try( :round, 2 )
  end

  def start_value=(val)
    scale = self.try( :user ).try( :temperature_scale )

    case scale
    when 'F'
      write_attribute( :start_value, val )
    when 'C'
      write_attribute( :start_value, celsius_to_fahrenheit(val) )
    else
      write_attribute( :start_value, val )
    end
  end

  def steps_graph_data
    graph_data = []
    time_offset = 0

    graph_data << [time_offset, self.start_value]
    
    if self.steps[0].step_type == TempProfileStep::STEP_TYPE[:hold]
      graph_data << [time_offset, self.steps[0].value]
    end

    self.steps.each do |step|
      time_offset += step.duration_for_device
      graph_data.concat( build_step(step, time_offset) )
    end

    graph_data
  end

  private

  def build_step(step, offset)
    next_step = self.steps[step.step_index]

    if TempProfileStep::STEP_TYPE[:hold] ==  next_step.try( :step_type )
      return [[offset, step.value], [offset, next_step.value]]
    else
      return [[offset, step.value]]
    end
  end

  def fahrenheit_to_celsius(degrees)
    (degrees.to_f - 32) / 1.8
  end

  def celsius_to_fahrenheit(degrees)
    degrees.to_f * 1.8 + 32
  end
end
