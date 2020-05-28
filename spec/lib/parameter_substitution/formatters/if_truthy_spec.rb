# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/if_truthy'

describe ParameterSubstitution::Formatters::IfTruthy do
  before do
    @format_class = ParameterSubstitution::Formatters::IfTruthy
  end

  it "has a key" do
    expect(@format_class.key).to eq("if_truthy")
  end

  it "provides a description" do
    expect(@format_class.description).to eq("If the input is truthy (i.e. [true, \"true\", \"t\", 1, \"1\", \"on\", \"yes\"]) then the input is replaced with the first argument. Otherwise, the input is replaced with the second argument.")
  end

  it "reports that it has parameters" do
    expect(@format_class.has_parameters?).to eq(true)
  end

  [true, "true", "t", "TRUE", "T", 1, "1", "on", "ON", "yes", "YES"].each do |value|
    context "when value is #{value.inspect} (truthy)" do
      it "returns first argument" do
        instance = @format_class.new("true_string", "false_string")
        expect(instance.format(value)).to eq("true_string")
      end
    end
  end

  [false, "false", "f", "FALSE", "F", 0, "0", "off", "OFF", "no", "NO", nil, "", 1234, "random string"].each do |value|
    context "when value is #{value.inspect} (not truthy)" do
      it "returns second argument" do
        instance = @format_class.new("true_string", "false_string")
        expect(instance.format(value)).to eq("false_string")
      end
    end
  end
end
