# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/date_time_iso8601'

describe ParameterSubstitution::Formatters::DateTimeIso8601 do
  context "Date Time ISO 8601 formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::DateTimeIso8601
    end

    it "have a key" do
      expect(@format_class.key).to eq("date_time_iso8601")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("iso8601 - 2017-04-11T15:55:10+00:00")
    end

    it "support converting times" do
      Time.zone = "Pacific Time (US & Canada)"
      expect(@format_class.format("2011-07-09 12:00:00")).to eq("2011-07-09T12:00:00-07:00")
      expect(@format_class.format('2017-01-01 09:47:18 -05:00')).to eq("2017-01-01T06:47:18-08:00")
      expect(@format_class.format('2017-01-01 21:47:18 -05:00')).to eq("2017-01-01T18:47:18-08:00")

      integer_time = Time.new(2011, 7, 9, 19, 0, 0).to_i
      expect(@format_class.format(integer_time)).to eq("2011-07-09T19:00:00-07:00")
    end
  end
end
