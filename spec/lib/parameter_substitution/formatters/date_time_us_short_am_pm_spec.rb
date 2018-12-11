# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/date_time_us_short_am_pm'

describe ParameterSubstitution::Formatters::DateTimeUsShortAmPm do
  context "Date Time US Short AM PM formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::DateTimeUsShortAmPm
    end

    it "have a key" do
      expect(@format_class.key).to eq("date_time_us_short_am_pm")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("MM/DD/YYYY hh:mm PM")
    end

    it "support converting times" do
      expect(@format_class.format("2011-07-09 12:00:00")).to eq("7/9/11 12:00 PM")
      expect(@format_class.format('2017-01-01 09:47:18 -05:00')).to eq("1/1/17  6:47 AM")
      expect(@format_class.format('2017-01-01 21:47:18 -05:00')).to eq("1/1/17  6:47 PM")

      integer_time = Time.new(2011, 7, 9, 19, 0, 0).to_i
      expect(@format_class.format(integer_time)).to eq("7/9/11  7:00 PM")
    end
  end
end
