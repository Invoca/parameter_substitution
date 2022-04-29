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

    it "converts 80+ character string to base64 without newline character" do
      # sha256 original value: cMwwWi7qNY3HdknYjir5H2kovw1RFIlelpznZs59K3sHZCDNgvzF5hgiPI0c3LF8NJH0b3W116A9mrnk50
      expect(@format_class.format("5329639ae1b9b6cf94e44e8021ce9c43ac1861b00bf9af3febfa0189b7d67c8b")). to eq("UyljmuG5ts+U5E6AIc6cQ6wYYbAL+a8/6/oBibfWfIs=")
      expect('UyljmuG5ts+U5E6AIc6cQ6wYYbAL+a8/6/oBibfWfIs='.unpack("m0").first.unpack('H*').first). to eq('5329639ae1b9b6cf94e44e8021ce9c43ac1861b00bf9af3febfa0189b7d67c8b')
    end
  end
end
