# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/add_prefix'

describe ParameterSubstitution::Formatters::AddPrefix do
  context "Add Prefix formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::AddPrefix
      @formatter = @format_class.new("prefix ")
    end

    it "have a key" do
      expect(@format_class.key).to eq("add_prefix")
    end

    it "provide a description" do
      expected = "This takes a prefix as a constructor parameter and prepends it to the value. If the value is blank, nothing is shown."
      expect(@format_class.description).to eq(expected)
    end

    it "report that it has parameters" do
      expect(@format_class.has_parameters?).to eq(true)
    end

    it "prefix various types" do
      expect(@formatter.format("transaction_id")).to eq("prefix transaction_id")
      expect(@formatter.format(1)).to eq("prefix 1")
      expect(Time.parse("2017-01-22")).to eq(@formatter.format("prefix 2017-01-22 00:00:00 -0800"))
      expect(@formatter.format(1.01)).to eq("prefix 1.01")
    end

    it "not be shown if nil or blank" do
      expect(@formatter.format(nil)).to be_nil
      expect(@formatter.format("")).to be_nil
    end
  end
end
