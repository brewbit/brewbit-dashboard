require 'json'

class DeviceMessageNotification
  attr_accessor :type, :data, :socket_id

  CHANNEL = 'device'

  TYPES = {
    activation_notification:    'activation_notification',
    activation_token_response:  'activation_token_response',
    auth_response:              'auth_response',
    device_report:              'device_report',
    send_update:                'send_update',
    send_update_info:           'send_update_info'
  }

  def build( type, socket_id, options = {} )

    @socket_id = socket_id

    case type
    when TYPES[:activation_notification]
      build_activation_notification options[:device_id]
    when TYPES[:activation_token_response]
      build_activation_token_response options[:activation_token]
    when TYPES[:auth_response]
      build_auth_response options[:authenticated]
    when TYPES[:device_report]
      build_device_report options[:sensors]
    when TYPES[:send_update]
      build_send_update options[:requested_version]
    when TYPES[:send_update_info]
      build_send_update_info options[:current_version]
    end
  end

  def serialize
    self.to_json
  end

  def deserialize( message )
    m = JSON.parse( message ).symbolize_keys

    @type = m[:type]
    @socket_id = m[:socket_id]

    case @type
    when TYPES[:activation_notification]
      @data = get_activation_notification_data( m[:data] )
    when TYPES[:activation_token_response]
      @data = get_activation_token_response_data m[:data]
    when TYPES[:auth_response]
      @data = get_auth_response_data m[:data]
    when TYPES[:device_report]
      @data = get_device_report_data m[:data]
    when TYPES[:send_update]
      @data = get_send_update_data m[:data]
    when TYPES[:send_update_info]
      @data = get_send_update_info_data m[:data]
    end
  end

  private

  def build_activation_notification( device_id )
    @type = TYPES[:activation_notification]
    @data = { device_id: device_id }
  end

  def build_activation_token_response( token )
    @type = TYPES[:activation_token_response]
    @data = { activation_token: token }
  end

  def build_auth_response( authenticated )
    @type = TYPES[:auth_response]
    @data = { authenticated: authenticated }
  end

  def build_device_report( sensors )
    @type = TYPES[:device_report]
    @data = { sensors: sensors }
  end

  def build_send_update( device_version )
    @type = TYPES[:send_update]
    @data = { requested_version: device_version }
  end

  def build_send_update_info( current_version )
    @type = TYPES[:send_update_info]
    @data = { current_version: current_version }
  end

  def get_activation_notification_data( data )
    { device_id: data['device_id'] }
  end

  def get_activation_token_response_data( data )
    { activation_token: data['activation_token'] }
  end

  def get_auth_response_data( data )
    { authenticated: data['authenticated'] }
  end

  def get_device_report_data( data )
    symbolized_data = data['sensors'].map { |p| p.symbolize_keys }

    { sensors: symbolized_data }
  end

  def get_send_update_data( data )
    { requested_version: data['requested_version'] }
  end

  def get_send_update_info_data( data )
    { current_version: data['current_version'] }
  end
end

