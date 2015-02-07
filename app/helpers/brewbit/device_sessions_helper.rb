module Brewbit
  module DeviceSessionsHelper
    
    def summarize_session_audit(audit)
      summarize_audit(audit, '')
    end
    
    def summarize_output_audit(audit)
      output_index = 2
      if audit.comment
        output_json = JSON.parse(audit.comment)
        output_index = output_json['output_index']
      end
      
      summarize_audit(audit, ['left ', 'right ', ''][output_index] + 'output') #  + audit.auditable.output_index
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
        summary = 'Removed ' + desc + ' ' + audit.audited_changes.to_s # TODO parse this out!
      when 'create'
        summary = 'Created ' + desc + ' ' + audit.audited_changes.to_s # TODO parse this out!
      else
        summary = audit.action + ' '

        audit.audited_changes.each do |changed_field, change_values|
          summary << changed_field.humanize.downcase + ' from ' + change_values.to_s
        end
      end

      summary
    end
  
    def summarize_field_change(field_name, field_values)
      translate_field_values field_name, field_values
      field_name.humanize.downcase + ' from ' + field_values[0].to_s + ' to ' + field_values[1].to_s
    end
    
    def translate_field_values(field_name, field_values)
      case field_name
      when 'temp_profile_id'
        field_values.map! {|c| "'" + TempProfile.find(c).name + "'" }
      when 'setpoint_type'
        field_values.map! {|a| ["'Static'", "'Temp Profile'"][a] }
      when 'function'
        field_values.map! {|a| ["'Heating'", "'Cooling'"][a] }
      when 'temp_profile_completion_action'
        field_values.map! {|a| ["'Hold Last Temp'", "'Start Over'"][a] }
      end
    end
  end
end
