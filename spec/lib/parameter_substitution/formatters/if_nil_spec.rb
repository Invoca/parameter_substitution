# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/if_nil'

describe ParameterSubstitution::Formatters::IfNil do
  context "If nil formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::IfNil
    end

    it "have a key" do
      expect(@format_class.key).to eq("if_nil")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Takes one new_value parameter. If the input is nil, the input is replaced with new_value.")
    end

    it "report that it has parameters" do
      expect(@format_class.has_parameters?).to eq(true)
    end

    it "return left most strings" do
      expect(@format_class.new("not_used").format("abcdefg")).to eq("abcdefg")
      expect(@format_class.new("not_used").format(false)).to eq(false)
      expect(@format_class.new("used").format(nil)).to eq("used")
    end
  end
end
