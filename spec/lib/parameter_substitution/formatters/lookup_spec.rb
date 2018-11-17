# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/lookup'

describe ParameterSubstitution::Formatters::Lookup do
  context "Lookup formatters test" do
    before do
      @format_class = ParameterSubstitution::Formatters::Lookup
      @formatter = @format_class.new(
        "value_to_lookup" => "value_to_return",
        "another_value_to_lookup" => "another_value_to_return",
        "1" => "this_one_exists"
      )
    end

    it "have a key" do
      expect(@format_class.key).to eq("lookup")
    end

    it "provides a description" do
      expect(@format_class.description).to eq("This takes a table as a constructor parameter and performs a lookup from the value. If the value exists as a key in the lookup table, the key's value is returned.")
    end

    it "reports that it has parameters" do
      expect(@format_class.has_parameters?).to eq(true)
    end

    it "returns value to return if value_to_lookup exists" do
      expect(@formatter.format("value_to_lookup")).to eq("value_to_return")
      expect(@formatter.format("another_value_to_lookup")).to eq("another_value_to_return")
      expect(@formatter.format("something else")).to eq(nil)
    end

    it "handles different data types and return the mapped value if it exists, and nil if it does not" do
      expect(@formatter.format(nil)).to eq(nil)
      expect(@formatter.format(Time.parse("2017-01-22"))).to eq(nil)
      expect(@formatter.format(1)).to eq("this_one_exists")
    end
  end
end
