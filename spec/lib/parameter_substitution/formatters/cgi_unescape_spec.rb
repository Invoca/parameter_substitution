# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/cgi_unescape'

describe ParameterSubstitution::Formatters::CgiUnescape do
  context "CGI Unescape formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::CgiUnescape
    end

    it "have a key" do
      expect(@format_class.key).to eq("cgi_unescape")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Url-decodes the string, preserves nil.")
    end

    it "prefix various types" do
      expect(@format_class.format("this+%28+has+%29+%2Bfunny%2B+characters%22+%22")).to eq("this ( has ) +funny+ characters\" \"")
      expect(@format_class.format("i am not so funny")).to eq("i am not so funny")
      expect(@format_class.format(12345678)).to eq("12345678")
      expect(@format_class.format(nil)).to eq(nil)
    end
  end
end
