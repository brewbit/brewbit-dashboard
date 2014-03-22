#
# Defaults
#
# function          - hot
# output_type       - right
# compressor_delay  - 3 minutes
#
class DefaultOutputBuilderService

  def initialize( function = Output::FUNCTIONS[:hot], index = 0, compressor_delay = 3 )
    attr = { function: function, output_index: index, compressor_delay: compressor_delay }
    @output = Output.new attr
  end

  def output
    @output
  end
end

