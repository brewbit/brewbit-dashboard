module TemperatureConverter

  def self.convert( scale, temperature )
    case scale
    when 'F'
      temperature
    when 'C'
      fahrenheit_to_celcius( temperature )
    else
      temperature
    end
  end

  def self.fahrenheit_to_celcius(degrees)
    (degrees.to_f - 32) / 1.8
  end
end

