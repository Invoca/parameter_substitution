# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/in_timezone'

describe ParameterSubstitution::Formatters::InTimezone do
  context "In timezone formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::InTimezone
    end

    it "have a key" do
      expect(@format_class.key).to eq("in_timezone")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Converts a date time to the specified time zone.")
    end

    it "support converting times" do
      expect(@format_class.new("Pacific Time (US & Canada)").format("2011-07-09 12:00:00")).to eq("2011-07-09 12:00:00")
      expect(@format_class.new("Mountain Time (US & Canada)").format("2011-07-09 12:00:00")).to eq("2011-07-09 13:00:00")

      integer_time = Time.new(2011, 7, 9, 19, 0, 0).to_i
      expect(@format_class.new("Pacific Time (US & Canada)").format(integer_time)).to eq("2011-07-09 19:00:00")
    end

    it "support converting things that are not times" do
      expect(@format_class.new("Pacific Time (US & Canada)").format("not a valid time")).to eq("not a valid time")
      expect(@format_class.new("Mountain Time (US & Canada)").format("2011-79-79 12:00:00")).to eq("2011-79-79 12:00:00")

      expect(@format_class.new("Pacific Time (US & Canada)").format(nil)).to eq(nil)
    end
  end
end
