## Generated from bbmt.proto for 
require "beefcake"

module ProtobufMessages

  class ActivationTokenRequest
    include Beefcake::Message
  end

  class ActivationTokenResponse
    include Beefcake::Message
  end

  class ActivationNotification
    include Beefcake::Message
  end

  class AuthRequest
    include Beefcake::Message
  end

  class AuthResponse
    include Beefcake::Message
  end

  class SensorReport
    include Beefcake::Message
  end

  class DeviceReport
    include Beefcake::Message
  end

  class Error
    include Beefcake::Message
  end

  class FirmwareUpdateCheckRequest
    include Beefcake::Message
  end

  class FirmwareUpdateCheckResponse
    include Beefcake::Message
  end

  class FirmwareDownloadRequest
    include Beefcake::Message
  end

  class FirmwareDownloadResponse
    include Beefcake::Message
  end

  class TempProfileStep
    include Beefcake::Message

    module TempProfileStepType
      HOLD = 0
      RAMP = 1
    end
  end

  class TempProfile
    include Beefcake::Message
  end

  class OutputSettings
    include Beefcake::Message

    module Function
      HEATING = 0
      COOLING = 1
      MANUAL = 2
    end

    module OutputControlMode
      ON_OFF = 0
      PID = 1
    end
  end

  class SensorSettings
    include Beefcake::Message

    module SetpointType
      STATIC = 0
      TEMP_PROFILE = 1
    end
  end

  class DeviceSettingsNotification
    include Beefcake::Message
  end

  class ApiMessage
    include Beefcake::Message

    module Type
      ACTIVATION_TOKEN_REQUEST = 1
      ACTIVATION_TOKEN_RESPONSE = 2
      ACTIVATION_NOTIFICATION = 3
      AUTH_REQUEST = 4
      AUTH_RESPONSE = 5
      DEVICE_REPORT = 6
      ERROR = 7
      FIRMWARE_UPDATE_CHECK_REQUEST = 8
      FIRMWARE_UPDATE_CHECK_RESPONSE = 9
      FIRMWARE_DOWNLOAD_REQUEST = 10
      FIRMWARE_DOWNLOAD_RESPONSE = 11
      DEVICE_SETTINGS_NOTIFICATION = 12
    end
  end

  class ActivationTokenRequest
    required :device_id, :string, 1
  end


  class ActivationTokenResponse
    optional :activation_token, :string, 1
  end


  class ActivationNotification
    required :auth_token, :string, 1
  end


  class AuthRequest
    required :device_id, :string, 1
    required :auth_token, :string, 2
  end


  class AuthResponse
    required :authenticated, :bool, 1
  end


  class SensorReport
    required :id, :uint32, 1
    required :value, :float, 2
    required :setpoint, :float, 3
  end


  class DeviceReport
    repeated :sensor_report, SensorReport, 1
  end


  class Error
    required :code, :uint32, 1
    required :body, :string, 2
  end


  class FirmwareUpdateCheckRequest
    required :current_version, :string, 1
  end


  class FirmwareUpdateCheckResponse
    required :update_available, :bool, 1
    optional :version, :string, 2
    optional :binary_size, :uint32, 3
  end


  class FirmwareDownloadRequest
    required :requested_version, :string, 1
  end


  class FirmwareDownloadResponse
    required :offset, :uint32, 1
    required :data, :bytes, 2
  end


  class TempProfileStep
    required :duration, :uint32, 1
    required :value, :float, 2
    required :type, TempProfileStep::TempProfileStepType, 3
  end


  class TempProfile
    required :id, :uint32, 1
    required :name, :string, 2
    required :start_value, :float, 3
    repeated :steps, TempProfileStep, 4
  end


  class OutputSettings
    required :id, :uint32, 1
    required :function, OutputSettings::Function, 2
    required :cycle_delay, :uint32, 3
    required :trigger_sensor_id, :uint32, 4
    required :output_mode, OutputSettings::OutputControlMode, 5
  end


  class SensorSettings
    required :id, :uint32, 1
    required :setpoint_type, SensorSettings::SetpointType, 2
    optional :static_setpoint, :float, 3
    optional :temp_profile_id, :uint32, 4
  end


  class DeviceSettingsNotification
    required :name, :string, 1
    repeated :output, OutputSettings, 2
    repeated :sensor, SensorSettings, 3
    repeated :temp_profiles, TempProfile, 4
  end


  class ApiMessage
    required :type, ApiMessage::Type, 1
    optional :activationTokenRequest, ActivationTokenRequest, 2
    optional :activationTokenResponse, ActivationTokenResponse, 3
    optional :activationNotification, ActivationNotification, 4
    optional :authRequest, AuthRequest, 5
    optional :authResponse, AuthResponse, 6
    optional :deviceReport, DeviceReport, 7
    optional :error, Error, 8
    optional :firmwareUpdateCheckRequest, FirmwareUpdateCheckRequest, 9
    optional :firmwareUpdateCheckResponse, FirmwareUpdateCheckResponse, 10
    optional :firmwareDownloadRequest, FirmwareDownloadRequest, 11
    optional :firmwareDownloadResponse, FirmwareDownloadResponse, 12
    optional :deviceSettingsNotification, DeviceSettingsNotification, 13
  end

end
