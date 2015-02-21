require 'stringio'

BUFFER_SIZE = 256

module File::Reverse
 
  def reverse_each_line buffer_size = BUFFER_SIZE, &block
    remainder = ""

    log_pos = self.size - buffer_size
    self.pos = log_pos >= 0 ? log_pos : 0

    left_to_read = self.size
    while left_to_read > 0
      read_len = left_to_read > buffer_size ? buffer_size : left_to_read
      left_to_read -= read_len
      self.pos = left_to_read

      # read a chunk
      buffer = StringIO.new(self.read(read_len), 'a+')
      buffer.write(remainder)
      last_newline_pos = buffer.size - 1

      # starting at end, read until a \n is encountered
      buffer.pos = (buffer.size-1)
      while buffer.pos > 0
        cur_pos = buffer.pos

        c = buffer.getc

        if c == "\n"
          line_len = last_newline_pos - cur_pos
          if line_len != 0
            yield buffer.read(line_len)
          end
          last_newline_pos = cur_pos
        end

        buffer.pos = cur_pos - 1
      end

      remainder = buffer.read(last_newline_pos+1)
    end

    unless remainder.empty?
      yield remainder
    end
  end
end
