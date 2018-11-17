# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/time_with_seconds'

describe ParameterSubstitution::Formatters::TimeWithSeconds do
  context "Time with seconds formatters test" do
    before do
      @format_class = ParameterSubstitution::Formatters::TimeWithSeconds
    end

    it "have a key" do
      expect(@format_class.key).to eq("time_with_seconds")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("hh:mm:ss")
    end

    it "support converting times" do
      expect(@format_class.format("2011-07-09 12:00:00")).to eq("12:00:00")
      expect(@format_class.format('2017-01-01 09:47:18 -05:00')).to eq("06:47:18")
      expect(@format_class.format('2017-01-01 21:47:18 -05:00')).to eq("18:47:18")

      integer_time = Time.new(2011, 7, 9, 19, 0, 0).to_i
      expect(@format_class.format(integer_time)).to eq("19:00:00")
    end
  end
end
