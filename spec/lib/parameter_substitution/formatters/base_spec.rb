# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/base'

describe ParameterSubstitution::Formatters::Base do
  context "Base formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::Base
    end

    it "requires derived classes to implement methods" do
      expect { @format_class.description }.to          raise_exception(NotImplementedError)
      expect { @format_class.format("base") }.to raise_exception(NotImplementedError)
    end

    it "have a key" do
      expect(@format_class.key).to eq("base")
    end

    it "report that it does not has parameters" do
      expect(@format_class.has_parameters?).to eq(false)
    end

    it "report that the encoding is raw" do
      expect(@format_class.encoding).to eq(:raw)
    end

    context "helper methods" do
      it "provide a helper method to parse durations" do
        expect(@format_class.parse_duration(30)).to eq(30)
        expect(@format_class.parse_duration("30")).to eq(30)
        expect(@format_class.parse_duration("00:30")).to eq(30)
        expect(@format_class.parse_duration("00:00:30")).to eq(30)

        expect(@format_class.parse_duration(330)).to eq(330)
        expect(@format_class.parse_duration("330")).to eq(330)
        expect(@format_class.parse_duration("05:30")).to eq(330)
        expect(@format_class.parse_duration("00:05:30")).to eq(330)

        expect(@format_class.parse_duration(3601)).to eq(3601)
        expect(@format_class.parse_duration("3601")).to eq(3601)
        expect(@format_class.parse_duration("01:00:01")).to eq(3601)

        expect(@format_class.parse_duration("1:08:27")).to eq(4107)
      end
    end
  end
end
