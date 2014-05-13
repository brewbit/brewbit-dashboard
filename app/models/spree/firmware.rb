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
    validates :channel, presence: true, inclusion: ['stable', 'unstable']
    validates :file, presence: true

    def self.latest( channel, with_data = false )
      if channel == 'unstable'
        channels = ['stable', 'unstable']
      else
        channels = 'stable'
      end
      
      if with_data
        select(column_names).where(channel: channels).order( 'version DESC' ).limit(1).first
      else
        select_without( [:file] ).where(channel: channels).order( 'version DESC' ).limit(1).first
      end
    end
    
    def self.is_latest?( channel, version )
      latest(channel).version == version
    end

    def size_in_kb
      ( self.size / 1024.0 ).round( 2 )
    end
    
    def chunk(offset, size)
      Base64.encode64(file[offset, size])
    end
    
    private

    def set_size
      self.size = file.try( :size )
    end
    
    def self.select_without( columns )
      select(column_names - columns.map(&:to_s))
    end
  end
end

