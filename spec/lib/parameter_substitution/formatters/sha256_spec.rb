# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/sha256'

describe ParameterSubstitution::Formatters::Sha256 do
  context "Sha256 formatters test" do
    before do
      @format_class = ParameterSubstitution::Formatters::Sha256
    end

    it "have a key" do
      expect(@format_class.key).to eq("sha256")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Generates a sha256 hash of the value.")
    end

    it "support converting different data types" do
      expect(@format_class.format("a string")).to eq("c0dc86efda0060d4084098a90ec92b3d4aa89d7f7e0fba5424561d21451e1758")
      expect(@format_class.format(1)).to eq("6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b")
      expect(@format_class.format(nil)).to eq("e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")
    end
  end
end
