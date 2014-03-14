class FirmwareSerializer
  include Enumerable

  CHUNK_SIZE = 1024

  def initialize( file_contents )
    @firmware = file_contents
  end

  def each( &block )
    total_size = @firmware.size
    total_chunks = total_size / CHUNK_SIZE
    left_over_bytes = @firmware.size % CHUNK_SIZE

    total_chunks.times do |i|
      start_point = CHUNK_SIZE * i
      end_point   = start_point + CHUNK_SIZE

      chunk = @firmware[start_point...end_point]

      block.call chunk
    end

    if left_over_bytes > 0
      start_point = total_chunks * CHUNK_SIZE
      end_point   = start_point + total_size

      chunk = @firmware[start_point...end_point]

      block.call chunk
    end
  end
end

