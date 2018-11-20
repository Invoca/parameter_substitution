# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/upper'

describe ParameterSubstitution::Formatters::Manager do
  context "Formatter Manager test" do
    before do
      @format_class = ParameterSubstitution::Formatters::Manager
    end

    it "provide default formatter class mapping" do
      expect(@format_class.default_formats).to be_a(Hash)
      expect(@format_class.default_formats["base"]).to eq("ParameterSubstitution::Formatters::Base")
    end

    it "includes formatter class mappings from the config" do
      expect(@format_class.all_formats).to be_a(Hash)
      expect(@format_class.all_formats["base"]).to eq("ParameterSubstitution::Formatters::Base")
      expect(@format_class.all_formats["test"]).to eq("TestClass")
    end

    it "return formatter class for key" do
      expect(@format_class.find("base")).to eq(ParameterSubstitution::Formatters::Base)
      expect(@format_class.find("test")).to eq(TestClass)
    end
  end
end
