class SessionEvent < ActiveRecord::Base
  belongs_to :device_session, touch: false
  
  def summary
    session_changes = self.event_data.clone
    output_changes = session_changes.delete('output_settings')

    fields = []
      
    session_changes.each do |field_name, field_value|
      fields << "#{field_name.humanize.downcase} = #{translate_field_value(field_name, field_value).to_s}"
    end

    unless output_changes.nil?
      output_changes.each do |os|
        output_index = os.delete('output_index')
        desc = ['left output', 'right output'][output_index]
        action = os.delete('action')
        if action == 'destroy'
          fields << "removed #{desc}"
        else
          os.each do |field_name, field_value|
            fields << "#{desc} #{field_name.humanize.downcase} = #{translate_field_value(field_name, field_value).to_s}"
          end
        end
      end
    end
      
    case self.event_type
    when 'create'
      action = 'Created'
    when 'update'
      action = 'Updated'
    end
      
    "#{action} session (#{fields.join(', ')})"
  end
    
  def translate_field_value(field_name, field_value)
    case field_name
    when 'temp_profile_id'
      begin
        "'" + TempProfile.find(field_value).name + "'"
      rescue
        "'???'"
      end
    when 'setpoint_type'
      ["static", "temp profile"][field_value]
    when 'function'
      ["heating", "cooling", "manual"][field_value]
    when 'temp_profile_completion_action'
      ["'hold last temp'", "'start over'"][field_value]
    when 'temp_profile_start_point'
      if field_value.to_i == -1
        "'current position'"
      else
        "'Step #{field_value.to_i + 1}'"
      end
    when 'static_setpoint'
      scale = device_session.try( :device ).try( :user ).try( :temperature_scale )
      label = (scale || "").empty? ? "" : "°#{scale}"
      "#{field_value.round(1)}#{label}"
    else
      field_value
    end
  end
end
