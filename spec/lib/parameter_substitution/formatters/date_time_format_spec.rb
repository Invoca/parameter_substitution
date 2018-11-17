# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/date_time_format'

describe ParameterSubstitution::Formatters::DateTimeFormat do
  context "Date Time formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::DateTimeFormat
      allow(Time).to receive(:now).and_return(Time.new(2017, 7, 9, 19, 0, 0))
      expect(Time.now.dst?).to be(true)
    end

    it "support converting from strings using a best guess" do
      expect(@format_class.parse_to_time("2011-07-09 12:00:00").to_s(:db)).to eq("2011-07-09 19:00:00")
      expect(@format_class.parse_to_time('2017-01-01 09:47:18 -05:00').to_s(:db)).to eq("2017-01-01 14:47:18")
      expect(@format_class.parse_to_time('2017-01-01 21:47:18 -05:00').to_s(:db)).to eq("2017-01-02 02:47:18")
    end

    it "support converting from unix time ms to times" do
      integer_time = Time.new(2011, 7, 9, 19, 0, 0).to_i * 1000 # Will be converted to UTC

      expect(@format_class.parse_to_time(integer_time).to_s(:db)).to eq("2011-07-10 02:00:00")
      expect(@format_class.parse_to_time(integer_time.to_s).to_s(:db)).to eq("2011-07-10 02:00:00")
    end

    it "support converting from unix time seconds to times" do
      integer_time = Time.new(2011, 7, 9, 19, 0, 0).to_i # Will be converted to UTC

      expect(@format_class.parse_to_time(integer_time).to_s(:db)).to eq("2011-07-10 02:00:00")
      expect(@format_class.parse_to_time(integer_time.to_s).to_s(:db)).to eq("2011-07-10 02:00:00")
    end

    it "Support Five9's absurd format - YYYYMMDDhhmmsssss" do
      integer_time = 20_160_727_212_335_707
      expect(@format_class.parse_to_time(integer_time).to_s(:db)).to eq("2016-07-27 21:23:35")
      expect(@format_class.parse_to_time(integer_time.to_s).to_s(:db)).to eq("2016-07-27 21:23:35")
    end

    it "not trip up on very long integers" do
      integer_time = 9_999_999_999_999_999_999_999
      expect(@format_class.parse_to_time(integer_time)).to eq(nil)
    end

    it "use the time zone set in Time.zone" do
      Time.zone = (Time.now.zone.in?(["PDT", "PST"]) ? "Central Time (US & Canada)" : "Pacific Time (US & Canada)")
      expect(Time.zone.now.zone).to_not eq(Time.now.zone)
      [[@format_class.parse_to_time("2011-07-09 12:00:00"), "Best guess format"],
       [@format_class.parse_to_time(Time.new(2011, 7, 9, 19, 0, 0).to_i * 1000), "Unix time ms"],
       [@format_class.parse_to_time(Time.new(2011, 7, 9, 19, 0, 0).to_i), "Unix time seconds"]].each do |parsed_time, description|
        expect(Time.zone.now.zone).to eq(parsed_time.zone), "Improper time zone used for #{description}"
      end
    end

    it "support converting from an arbitrary formatting with no time zone param passed" do
      time = DateTime.strptime("07/29/2017 11:44:27 PM", '%m/%d/%Y %I:%M:%S %p')
      expect(@format_class.parse_to_time("07/29/2017 11:44:27 PM", from_formatting: '%m/%d/%Y %I:%M:%S %p')).to eq(time)
    end

    it "accept both from_formatting and from_time_zone" do
      time = DateTime.strptime("07/29/2017 11:44:27 PM -0700", '%m/%d/%Y %I:%M:%S %p %z')
      expect(@format_class.parse_to_time("07/29/2017 11:44:27 PM", from_formatting: '%m/%d/%Y %I:%M:%S %p %z', from_time_zone: "Pacific Time (US & Canada)")).to eq(time)
    end

    it "override time zone when passed as a value to format and format options" do
      time_with_time_zone = "07/29/2017 11:44:27 PM -0700"
      expected_time = DateTime.strptime(time_with_time_zone, '%m/%d/%Y %I:%M:%S %p %z')
      result = @format_class.parse_to_time(time_with_time_zone, from_formatting: '%m/%d/%Y %I:%M:%S %p %z', from_time_zone: "Mountain Time (US & Canada)")
      expect(result).to eq(expected_time)
    end

    it "raise an exception if an invalid from_time_zone is passed" do
      time_without_time_zone = "07/29/2017 11:44:27 AM"
      invalid_from_time_zone = "Mars (US & Canada)"
      expect { @format_class.parse_to_time(time_without_time_zone, from_formatting: '%m/%d/%Y %I:%M:%S %p %z', from_time_zone: invalid_from_time_zone) }.to raise_error("Invalid from_time_zone argument #{invalid_from_time_zone} See ActiveSupport::TimeZone")
    end
  end
end
