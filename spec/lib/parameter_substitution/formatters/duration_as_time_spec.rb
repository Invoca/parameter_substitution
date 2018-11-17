# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/duration_as_time'

describe ParameterSubstitution::Formatters::DurationAsTime do
  context "Duration as Time formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::DurationAsTime
    end

    it "have a key" do
      expect(@format_class.key).to eq("duration_as_time")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Converts a duration in seconds into hh:mm:ss")
    end

    it "support converting durations" do
      expect(@format_class.format(0)).to eq("00:00:00")
      expect(@format_class.format(29)).to eq("00:00:29")
      expect(@format_class.format(299)).to eq("00:04:59")
      expect(@format_class.format(3601)).to eq("01:00:01")
      expect(@format_class.format(36010)).to eq("10:00:10")
    end

    it "handle string durations, using 0 if the string is not an integer" do
      expect(@format_class.format(29)).to eq("00:00:29")
      expect(@format_class.format('thirty')).to eq("00:00:00")
    end

    it "recognize duration formats" do
      expect(@format_class.format("00:00:29")).to eq("00:00:29")
      expect(@format_class.format("00:29")).to eq("00:00:29")

      expect(@format_class.format("00:01:29")).to eq("00:01:29")
      expect(@format_class.format("01:29")).to eq("00:01:29")
    end
  end
end
