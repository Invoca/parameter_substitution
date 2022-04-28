# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/hex_to_base64'

describe ParameterSubstitution::Formatters::HexToBase64 do
  context "HexToBase64 formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::HexToBase64
    end

    it "have a key" do
      expect(@format_class.key).to eq("hex_to_base64")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Converts hex encoded strings to base64 encoding")
    end

    it "converts to base64" do
      # sha256 original value: TestValue5678
      expect(@format_class.format("fd2cf6d725e3ff42ec13be7107d4c333b691fc8cec1b9aca562c5f9848471e9d")).to eq("/Sz21yXj/0LsE75xB9TDM7aR/IzsG5rKVixfmEhHHp0=")
    end
  end
end
