# Attributes:
# * file [binary]     - Firmware binary file contents
# * size [integer]    - Size of the binary file
# * version [string]  - Version of the binary file
#
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time
module Spree
  class Firmware < ActiveRecord::Base

    self.table_name = 'firmwares'

    before_validation :set_size

    validates :version, presence: true,
                        uniqueness: true,
                        format: { with: /[0-9]{0,3}\.[0-9]{0,3}\.[0-9]{0,3}(-[0-9a-fA-F]{7,40})?/,
                                  message: 'Please use semantic versioning format' }
    validates :size, presence: true, numericality: { only_integer: true }
    validates :file, presence: true

    def self.is_latest?( version )
      Spree::Firmware.order( 'version DESC' ).limit(1).pluck( :version ).first == version
    end

    def size_in_kb
      ( self.size / 1024.0 ).round( 2 )
    end

    private

    def set_size
      self.size = file.try( :size )
    end
  end
end

