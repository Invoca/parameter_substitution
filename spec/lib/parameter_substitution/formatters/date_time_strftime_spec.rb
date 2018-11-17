# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/date_time_strftime'

describe ParameterSubstitution::Formatters::DateTimeStrftime do
  context "Date Time Strftime formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::DateTimeStrftime
    end

    it "have a key" do
      expect(@format_class.key).to eq("date_time_strftime")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Formats a DateTime with the provided format string.")
    end

    it "report that it has parameters" do
      expect(@format_class.has_parameters?).to eq(true)
    end

    it "support converting times" do
      example_time = Time.new(2017, 6, 8, 7, 32, 49)
      format1 = @format_class.new("%Y-%m-%d %H:%M:%S %:z")
      format2 = @format_class.new("%m/%d/%Y/%H/%M/%S")

      expect(format1.format(example_time)).to eq("2017-06-08 07:32:49 -07:00")
      expect(format1.format(example_time.to_i)).to eq("2017-06-08 07:32:49 -07:00")
      expect(format2.format(example_time)).to eq("06/08/2017/07/32/49")
    end

    it "not raise on invalid date" do
      format1 = @format_class.new("%Y-%m-%d %H:%M:%S %:z")
      expect(format1.format(9_999_999_999_999_999_999_999)).to eq("")
    end
  end
end
