# frozen_string_literal: true

require_relative '../../../lib/parameter_substitution/encoder'

describe ParameterSubstitution::Encoder do
  context "EscapeHander" do
    it "do nothing if the source and destionation encodings are the same" do
      ParameterSubstitution::Encoder::ENCODINGS.each do |key|
        expect(:not_changed).to eq(ParameterSubstitution::Encoder.encode(:not_changed, key, key, "not used", false))
      end
    end

    # xml:             "XML encode",
    # angle_brackets:  "Content converted to a string and placed in angle brackets",
    # json:            "json encode",
    # raw:             "content is not changed",

    it "perform the required escaping" do
      expect("has+escaping").to eq(ParameterSubstitution::Encoder.encode("has escaping", :cgi, :raw, "not used", false))
      expect("has&gt;escaping").to eq(ParameterSubstitution::Encoder.encode("has>escaping", :html, :raw, "not used", false))
      expect("[\"red\",\"green\",\"blue\"]").to eq(ParameterSubstitution::Encoder.encode(["red", "green", "blue"], :json, :raw, "not used", false))
      expect("<color>red</color><color>green</color><color>blue</color>").to eq(ParameterSubstitution::Encoder.encode(["red", "green", "blue"], :xml, :raw, "colors", false))
      expect("<has escaping>").to eq(ParameterSubstitution::Encoder.encode("has escaping", :angle_brackets, :raw, "not used", false))
    end

    it "preserve quotes when handling json formatting" do
      # When starting outside of quotes
      expect("\"carrot\"").to eq(ParameterSubstitution::Encoder.encode("carrot", :json, :raw, "not used", false))
      expect("[\"carrot\"]").to eq(ParameterSubstitution::Encoder.encode(["carrot"], :json, :raw, "not used", false))

      # When starting inside quotes
      expect("carrot").to eq(ParameterSubstitution::Encoder.encode("carrot", :json, :raw, "not used", true))
      expect("[\\\"carrot\\\"]").to eq(ParameterSubstitution::Encoder.encode(["carrot"], :json, :raw, "not used", true))

      # When the original encoding is json but we are inside quotes
      expect("[\\\"carrot\\\"]").to eq(ParameterSubstitution::Encoder.encode("[\"carrot\"]", :json, :json, "not used", true))
      expect("[\\\"carrot\\\"]").to eq(ParameterSubstitution::Encoder.encode(["carrot"], :json, :raw, "not used", true)) # When starting outside of quotes
    end

    it "handle different encoding inside of strings for different parameter data types" do
      # When starting outside of quotes
      expect("1").to eq(ParameterSubstitution::Encoder.encode(1, :json, :raw, "not used", false))
      expect("1").to eq(ParameterSubstitution::Encoder.encode(1, :json, :raw, "not used", true))

      expect("[1]").to eq(ParameterSubstitution::Encoder.encode([1], :json, :raw, "not used", false))
      expect("[1]").to eq(ParameterSubstitution::Encoder.encode([1], :json, :raw, "not used", true))

      expect("[1,2]").to eq(ParameterSubstitution::Encoder.encode([1,2], :json, :raw, "not used", false))
      expect("[1,2]").to eq(ParameterSubstitution::Encoder.encode([1,2], :json, :raw, "not used", true))

      expect("[\"1\",\"2\"]").to eq(ParameterSubstitution::Encoder.encode(["1","2"], :json, :raw, "not used", false))
      expect("[\\\"1\\\",\\\"2\\\"]").to eq(ParameterSubstitution::Encoder.encode(["1","2"], :json, :raw, "not used", true))
    end
  end
end
