# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/blank_if_nil'

describe ParameterSubstitution::Formatters::BlankIfNil do
  context "Blank if Nil formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::BlankIfNil
    end

    it "have a key" do
      expect(@format_class.key).to eq("blank_if_nil")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Converts nil values to empty strings: ''")
    end

    it "replace nil values with blanks" do
      expect(@format_class.format("This is not nil")).to eq("This is not nil")
      expect(@format_class.format(123)).to eq(123)
      expect(@format_class.format(nil)).to eq("")
    end
  end
end
