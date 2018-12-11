# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/date_year_first_dashes'

describe ParameterSubstitution::Formatters::DateYearFirstDashes do
  context "Date Year First Dashes formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::DateYearFirstDashes
    end

    it "have a key" do
      expect(@format_class.key).to eq("date_year_first_dashes")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("YYYY-MM-DD")
    end

    it "support converting times" do
      expect(@format_class.format("2011-07-09 12:00:00")).to eq("2011-07-09")
      expect(@format_class.format('2017-01-01 09:47:18 -05:00')).to eq("2017-01-01")
      expect(@format_class.format('2017-01-01 21:47:18 -05:00')).to eq("2017-01-01")

      integer_time = Time.new(2011, 7, 9, 19, 0, 0).to_i
      expect(@format_class.format(integer_time)).to eq("2011-07-09")
    end
  end
end
