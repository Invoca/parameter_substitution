# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/upper'

class CustomManager < ParameterSubstitution::Formatters::Manager
  class << self
    def all_formats
      default_formatter_mapping.merge("test" => "TestClass")
    end
  end
end

describe ParameterSubstitution::Formatters::Manager do
  context "Formatter Manager test" do
    before do
      @format_class = ParameterSubstitution::Formatters::Manager
    end

    it "provide default formatter class mapping" do
      expect(@format_class.default_formatter_mapping).to be_a(Hash)
      expect(@format_class.default_formatter_mapping["base"]).to eq("ParameterSubstitution::Formatters::Base")

      expect(CustomManager.default_formatter_mapping).to be_a(Hash)
      expect(CustomManager.default_formatter_mapping["base"]).to eq("ParameterSubstitution::Formatters::Base")
    end

    it "provide overwritable formatter class mapping" do
      expect(@format_class.all_formats).to be_a(Hash)
      expect(@format_class.all_formats["base"]).to eq("ParameterSubstitution::Formatters::Base")

      expect(CustomManager.all_formats).to be_a(Hash)
      expect(CustomManager.all_formats["base"]).to eq("ParameterSubstitution::Formatters::Base")
      expect(CustomManager.all_formats["test"]).to eq("TestClass")
    end

    it "return formatter class for key" do
      expect(@format_class.find("base")).to eq(ParameterSubstitution::Formatters::Base)
      expect(CustomManager.find("test")).to eq("TestClass".constantize)
    end
  end
end
