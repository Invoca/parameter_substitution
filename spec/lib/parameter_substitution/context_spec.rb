# frozen_string_literal: true

require_relative '../../../lib/parameter_substitution/context'

describe ParameterSubstitution::Context do
  def build_context(options = {})
    default = {
      input:                                "<this> and not <that>",
      mapping:                              { "This" => "that", "That" => "this" },
      required_parameters:                  [],
      parameter_start:                      "<",
      parameter_end:                        ">",
      destination_encoding:                 :text,
      allow_unknown_replacement_parameters: false,
      allow_nil:                            false
    }

    ParameterSubstitution::Context.new(**default.merge(options))
  end

  context "Context" do
    it "be constructable" do
      context = ParameterSubstitution::Context.new(
        input:   "<this> and not <that>",
        mapping: { "this" => "that", "that" => "this" }
      )

      expect("<this> and not <that>").to eq(context.input)
      expect("this" => "that", "that" => "this").to eq(context.mapping)
      expect([]).to eq(context.required_parameters)
      expect('<').to eq(context.parameter_start)
      expect('>').to eq(context.parameter_end)
      expect(:text).to eq(context.destination_encoding)
      expect(context.allow_unknown_replacement_parameters).to be(false)
      expect(context.allow_nil).to be(false)
    end

    context "#allow_unknown_params?" do
      it "match allow_unknown_replacement_parameters if not json" do
        expect(build_context(allow_unknown_replacement_parameters: false).allow_unknown_params?(false)).to be(false)
        expect(build_context(allow_unknown_replacement_parameters: true).allow_unknown_params?(false)).to be(true)
      end

      it "match inside_quotes if json and not allow_unknown..." do
        context = build_context(allow_unknown_replacement_parameters: false, destination_encoding: :json)
        expect(context.allow_unknown_params?(false)).to be(false)
        expect(context.allow_unknown_params?(true)).to be(true)
      end
    end

    context "#mapping_has_key?" do
      it "match keys that exist" do
        context = build_context

        expect(context.mapping_has_key?("This")).to be(true)
        expect(context.mapping_has_key?("That")).to be(true)

        expect(context.mapping_has_key?("Other")).to be(false)
      end

      it "report matching mapping keys case insensitively" do
        context = build_context

        expect(context.mapping_has_key?("This")).to be(true)
        expect(context.mapping_has_key?("this")).to be(true)
        expect(context.mapping_has_key?("tHIS")).to be(true)
      end
    end
  end
end
