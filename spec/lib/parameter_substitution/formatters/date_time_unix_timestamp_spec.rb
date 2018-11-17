# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/date_time_unix_timestamp'

describe ParameterSubstitution::Formatters::DateTimeUnixTimestamp do
  context "Date Time Unix Timestamp formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::DateTimeUnixTimestamp
    end

    it "have a key" do
      expect(@format_class.key).to eq("date_time_unix_timestamp")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("unix timestamp")
    end

    it "support converting times" do
      expect(@format_class.format("2011-07-09 12:00:00")).to eq(1_310_238_000)

      integer_time = Time.new(2011, 7, 9, 19, 0, 0).to_i
      expect(@format_class.format(integer_time)).to eq(integer_time)
    end
  end
end
