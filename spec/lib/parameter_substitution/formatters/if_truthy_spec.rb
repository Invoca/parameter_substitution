# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/if_truthy'

describe ParameterSubstitution::Formatters::IfTruthy do
  context "If truthy formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::IfTruthy
    end

    it "have a key" do
      expect(@format_class.key).to eq("if_truthy")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("If the input is truthy (i.e. true, t, 1) then the input is replaced with the first argument. Otherwise, the input is replaced with the second argument.")
    end

    it "report that it has parameters" do
      expect(@format_class.has_parameters?).to eq(true)
    end

    [true, "true", "t", "TRUE", "T", 1, "1"].each do |value|
      it "return true string when value is #{value.inspect}" do
        instance = @format_class.new("true_string", "false_string")
        expect(instance.format(value)).to eq("true_string")
      end
    end

    [false, "false", "f", "FALSE", "F", 0, "0", nil, "", 1234, "random string"].each do |value|
      it "return false string when value is #{value.inspect}" do
        instance = @format_class.new("true_string", "false_string")
        expect(instance.format(value)).to eq("false_string")
      end
    end
  end
end
