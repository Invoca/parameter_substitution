# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/date_time_utc_year_first_dashes_seconds'

describe ParameterSubstitution::Formatters::DateTimeUtcYearFirstDashesSeconds do
  context "Date Time UTC Year first dashes seconds formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::DateTimeUtcYearFirstDashesSeconds
    end

    it "have a key" do
      expect(@format_class.key).to eq("date_time_utc_year_first_dashes_seconds")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("2017-04-11 15:55:10 (UTC)")
    end

    it "support converting times" do
      expect(@format_class.format("2011-07-09 12:00:00")).to eq("2011-07-09 19:00:00")
      expect(@format_class.format('2017-01-01 09:47:18 -05:00')).to eq("2017-01-01 14:47:18")
      expect(@format_class.format('2017-01-01 21:47:18 -05:00')).to eq("2017-01-02 02:47:18")

      integer_time = Time.new(2011, 7, 9, 19, 0, 0).to_i
      expect(@format_class.format(integer_time)).to eq("2011-07-10 02:00:00")
    end
  end
end
