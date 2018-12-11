# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/duration_as_seconds'

describe ParameterSubstitution::Formatters::DurationAsSeconds do
  context "Duration as Seconds formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::DurationAsSeconds
    end

    it "have a key" do
      expect(@format_class.key).to eq("duration_as_seconds")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Converts a duration to an integer value of seconds")
    end

    it "support converting durations" do
      expect(@format_class.format("55")).to eq(55)
      expect(@format_class.format("04:59")).to eq(299)
      expect(@format_class.format("00:01:30")).to eq(90)
      expect(@format_class.format("00:00:15")).to eq(15)
      expect(@format_class.format("01:00:01")).to eq(3601)
    end

    it "handle string durations, using 0 if the string is not an integer" do
      expect(@format_class.format("00:00:29")).to eq(29)
      expect(@format_class.format('thirty')).to eq(0)
    end

    it "return integer inputs" do
      expect(@format_class.format(29)).to eq(29)
    end
  end
end
