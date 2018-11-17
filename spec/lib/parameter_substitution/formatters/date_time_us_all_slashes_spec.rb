# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/date_time_us_all_slashes'

describe ParameterSubstitution::Formatters::DateTimeUsAllSlashes do
  context "Date Time US All Slashes formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::DateTimeUsAllSlashes
    end

    it "have a key" do
      expect(@format_class.key).to eq("date_time_us_all_slashes")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("MM/DD/YYYY/hh/mm/ss")
    end

    it "support converting times" do
      expect(@format_class.format("2011-07-09 12:00:00")).to eq("07/09/2011/12/00/00")
      expect(@format_class.format('2017-01-01 09:47:18 -05:00')).to eq("01/01/2017/06/47/18")
      expect(@format_class.format('2017-01-01 21:47:18 -05:00')).to eq("01/01/2017/18/47/18")

      integer_time = Time.new(2011, 7, 9, 19, 0, 0).to_i
      expect(@format_class.format(integer_time)).to eq("07/09/2011/19/00/00")
    end
  end
end
