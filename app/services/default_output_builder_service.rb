#
# Defaults
#
# function          - hot
# output_type       - right
# compressor_delay  - 3 minutes
#
class DefaultOutputBuilderService

  def initialize( function = Output::FUNCTIONS[:hot], type = Output::TYPES[:right], compressor_delay = 3 )
    attr = { function: function, output_type: type, compressor_delay: compressor_delay }
    @output = Output.new attr
  end

  def output
    @output
  end
end

