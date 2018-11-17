# frozen_string_literal: true

class ParameterSubstitution::Formatters::DateTimeFormat < ParameterSubstitution::Formatters::Base
  MINIMUM_INTEGER_TIME = Time.new(2000, 0o1, 0o1).to_i

  class << self
    def parse_to_time(value, parse_options = nil)
      from_custom_time(value, parse_options) ||
        from_yyyymmddhhmmssss(value) ||
        from_unix_time_ms(value) ||
        from_unix_time_sec(value) ||
        from_parse(value)
    rescue ArgumentError => ex
      ex.message =~ /invalid date/ || ex.message =~ /argument out of range/ or raise
      nil
    end

    def from_yyyymmddhhmmssss(value)
      candidate = value.to_s.strip
      candidate =~ /\d{14}/ && DateTime.strptime(candidate[0, 14], '%Y%m%d%H%M%S')
    end

    def from_unix_time_sec(value)
      (value.to_f > MINIMUM_INTEGER_TIME) && Time.zone.at(value.to_f)
    end

    def from_unix_time_ms(value)
      (value.to_i / 1000 > MINIMUM_INTEGER_TIME) && Time.zone.at(value.to_f / 1000)
    end

    def from_parse(value)
      Time.zone.parse(value.to_s)
    end

    def from_custom_time(value, parse_options)
      # parse_options = { from_formatting: "%m-%d-%Y %h %m %z", from_time_zone: "Pacific Time (US & Canada)" }
      if parse_options && parse_options[:from_formatting]
        from_time_zone_with_dst = parse_options[:from_time_zone].presence && parse_time_zone_offset(parse_options[:from_time_zone])
        DateTime.strptime("#{value} #{from_time_zone_with_dst}", parse_options[:from_formatting])
      end
    end

    private

    def parse_time_zone_offset(from_time_zone)
      if (time_zone = ActiveSupport::TimeZone.new(from_time_zone))
        time_zone.now.formatted_offset
      else
        raise "Invalid from_time_zone argument #{from_time_zone} See ActiveSupport::TimeZone"
      end
    end
  end
end
