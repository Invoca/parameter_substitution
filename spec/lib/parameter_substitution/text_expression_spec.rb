# frozen_string_literal: true

require_relative '../../../lib/parameter_substitution/text_expression'

describe ParameterSubstitution::TextExpression do
  context "TextExpression" do
    it "is constructed with a text value" do
      text_expression = ParameterSubstitution::TextExpression.new("some long winded text")

      expect(text_expression.value).to eq("some long winded text")
      expect(text_expression.unknown_parameters(false)).to be_nil
    end

    it "just pass the value along in evaluate" do
      text_expression = ParameterSubstitution::TextExpression.new("some long winded text")

      expect(text_expression.evaluate(true)).to eq("some long winded text")
      expect(text_expression.evaluate(false)).to eq("some long winded text")
    end

    context "ends_inside_quotes" do
      it "preserve the quote state when no quotes occur in the input." do
        text_expression = ParameterSubstitution::TextExpression.new("some long winded text")

        expect(text_expression.ends_inside_quotes(started_inside_quotes: false)).to eq(false)
        expect(text_expression.ends_inside_quotes(started_inside_quotes: true)).to eq(true)
      end

      it "toggle the quote state if a quote occurs" do
        text_expression = ParameterSubstitution::TextExpression.new("some long winded \"text")

        expect(text_expression.ends_inside_quotes(started_inside_quotes: false)).to eq(true)
        expect(text_expression.ends_inside_quotes(started_inside_quotes: true)).to eq(false)
      end
    end
  end
end
