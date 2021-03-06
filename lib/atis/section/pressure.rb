class ATIS::Section::Pressure < ATIS::Section::Base

  uses :metar, group: :pressure

  format :en do
    message.report_pressure_in.each do |pressure_type|

      block pressure_type.downcase.to_sym

      case pressure_type.downcase.to_sym
        when :qfe
          text mm_from_hpa(qfe_from(pressure.pressure)).floor
          block :mm
          block :or
          text qfe_from(pressure.pressure).floor
        when :qnh
          text pressure.pressure.to_i
          block :or
          text mm_from_hpa(pressure.pressure).floor
          block :mm
      end

    end
  end

  format :ru do
    message.report_pressure_in.each do |pressure_type|
      if message.report_pressure_in == ["QFE"]
        block :pressure
      else
        block pressure_type.downcase.to_sym
      end

      case pressure_type.downcase.to_sym
        when :qfe
          digit_conversion mm_from_hpa(qfe_from(pressure.pressure)).floor
          block :or
          digit_conversion qfe_from(pressure.pressure).floor
          block :hpa
        when :qnh
          digit_conversion pressure.pressure.to_i
          block :hpa
          block :or
          digit_conversion mm_from_hpa(pressure.pressure).floor
      end

    end
  end

  def pressure
    source.first
  end

  def qfe_from(qnh)
    qnh = qnh.to_i
    airport = Airport.where(icao: metar.aerodrome.first.icao).first
    return qnh unless airport.present?

    (qnh - (Converter.feet_to_meters(airport.elevation)/9))

  end

  def mm_from_hpa(hpa)
    (hpa.to_i * 0.750098697)
  end
end