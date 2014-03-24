#
# Defaults
#
# function          - hot
# output_type       - right
# cycle_delay  - 3 minutes
#
class DefaultOutputBuilderService

  def initialize( function = Output::FUNCTIONS[:hot], index = 0, cycle_delay = 3 )
    attr = { function: function, output_index: index, cycle_delay: cycle_delay }
    @output = Output.new attr
  end

  def output
    @output
  end
end

