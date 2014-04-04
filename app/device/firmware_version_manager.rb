class FirmwareVersionManager

  class FirmwareNotFound < Exception ; end

  def self.update_available?( current_version )
    result = (Spree::Firmware.is_latest?(current_version))
    !result
  end

  def self.get_firmware( version )
    firmware = (Spree::Firmware.find_by_version(version))
    firmware
  end

  def self.get_latest_version_info
    firmware = (Spree::Firmware.order( 'version DESC' ).limit(1).first())
    build_firmware_info( firmware )
  end

  private

  def self.build_firmware_info( firmware )
    return nil if firmware.blank?

    { version: firmware.version, size: firmware.size }
  end
end

