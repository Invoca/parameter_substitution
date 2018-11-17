# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/duration_grouped_by_description'

describe ParameterSubstitution::Formatters::DurationGroupedByDescription do
  context "Duration grouped by description formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::DurationGroupedByDescription
    end

    it "have a key" do
      expect(@format_class.key).to eq("duration_grouped_by_description")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Converts a duration in seconds into one of the following: <30sec,30-60sec,1-5min,5-10min,10-20min,20-30min,30-60min,>60min")
    end

    it "support converting durations" do
      expect(@format_class.format(-1)).to eq("<30sec")
      expect(@format_class.format(0)).to eq("<30sec")
      expect(@format_class.format(29)).to eq("<30sec")
      expect(@format_class.format(30)).to eq("30-60sec")
      expect(@format_class.format(59)).to eq("30-60sec")
      expect(@format_class.format(60)).to eq("1-5min")
      expect(@format_class.format(299)).to eq("1-5min")
      expect(@format_class.format(300)).to eq("5-10min")
      expect(@format_class.format(599)).to eq("5-10min")
      expect(@format_class.format(600)).to eq("10-20min")
      expect(@format_class.format(1199)).to eq("10-20min")
      expect(@format_class.format(1200)).to eq("20-30min")
      expect(@format_class.format(1799)).to eq("20-30min")
      expect(@format_class.format(1800)).to eq("30-60min")
      expect(@format_class.format(3599)).to eq("30-60min")
      expect(@format_class.format(3600)).to eq(">60min")
      expect(@format_class.format(1_800_000_000)).to eq(">60min")
    end

    it "handle string durations, using 0 if the string is not an integer" do
      expect(@format_class.format('30')).to eq("30-60sec")
      expect(@format_class.format('thirty')).to eq("<30sec")
    end

    it "handle formatted string durations" do
      expect(@format_class.format('00:00:30')).to eq("30-60sec")
      expect(@format_class.format('00:05:30')).to eq("5-10min")

      expect(@format_class.format('00:30')).to eq("30-60sec")
      expect(@format_class.format('05:30')).to eq("5-10min")

      expect(@format_class.format('01:30:00')).to eq(">60min")
    end
  end
end
