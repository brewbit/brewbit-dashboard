
module FirmwareVersionManager

  class FirmwareNotFound < Exception ; end

  def self.update_available?( current_version )
    !Firmware.is_latest? current_version
  end

  def self.get_firmware( version )
    Firmware.find_by_version( version )
  end

  def self.get_latest_version_info
    firmware = Firmware.order( 'version DESC' ).limit(1).first
    build_firmware_info( firmware )
  end

  private

  def self.build_firmware_info( firmware )
    return nil if firmware.blank?

    { version: firmware.version, size: firmware.size }
  end
end

