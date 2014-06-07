module TemperatureConverter

  def self.convert( scale, temperature )
    case scale
    when 'F'
      temperature
    when 'C'
      fahrenheit_to_celsius( temperature )
    else
      temperature
    end
  end

  def self.fahrenheit_to_celsius(degrees)
    (degrees.to_f - 32) / 1.8
  end

  def self.celsius_to_fahrenheit(degrees)
    (degrees.to_f * 1.8) + 32
  end
end

