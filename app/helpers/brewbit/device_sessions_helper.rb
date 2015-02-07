module Brewbit
  module DeviceSessionsHelper
    
    def summarize_session_audit(audit)
      changes = audit.audited_changes.collect {|c| c }
      output_index = 2
      if audit.comment
        output_json = JSON.parse(audit.comment)
        output_index = output_json['output_index']
      elsif audit.action == 'destroy'
        output_index = audit.audited_changes['output_index']
      end
      
      summarize_audit(audit, ['left output', 'right output', 'session'][output_index])
    end
    
    def summarize_audit(audit, desc)
      summary = nil
      case audit.action
      when 'update'
        changes = []
        audit.audited_changes.each do |field_name, field_values|
          changes << summarize_field_change(field_name, field_values)
        end
      
        summary = 'Changed ' + desc + ' ' + changes.join(', ')
      when 'destroy'
        summary = 'Removed ' + desc
      when 'create'
        fields = []
        audit.audited_changes.each do |field_name, field_value|
          if field_name != 'output_index'
            fields << field_name.humanize.downcase + ' = ' + translate_field_value(field_name, field_value).to_s
          end
        end
      
        summary = 'Created ' + desc + ': ' + fields.join(', ')
      else
        summary = audit.action + ' '

        audit.audited_changes.each do |changed_field, change_values|
          summary << changed_field.humanize.downcase + ' from ' + change_values.to_s
        end
      end

      summary
    end
  
    def summarize_field_change(field_name, field_values)      
      field_values.map! {|field_value| translate_field_value field_name, field_value }
      field_name.humanize.downcase + ' from ' + field_values[0].to_s + ' to ' + field_values[1].to_s
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
        ["heating", "cooling"][field_value]
      when 'temp_profile_completion_action'
        ["'hold last temp'", "'start over'"][field_value]
      else
        field_value
      end
    end
  end
end
