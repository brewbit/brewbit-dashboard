module Brewbit::DeviceSessionsHelper
  def summarize_audit(audit)
    summary = nil
    case audit.action
    when "update"
      summary = "Changed "
    
      audit.audited_changes.each do |changed_field, change_values|
        summary << changed_field.humanize.downcase + " from " + change_values[0].to_s + " to " + change_values[1].to_s
      end
    else
      summary = audit.action + " "

      audit.audited_changes.each do |changed_field, change_values|
        summary << changed_field.humanize.downcase + " from " + change_values.to_s
      end
    end

    summary
  end
end
