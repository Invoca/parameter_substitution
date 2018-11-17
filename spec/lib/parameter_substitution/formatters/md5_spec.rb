# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/md5'

describe ParameterSubstitution::Formatters::Md5 do
  context "Md5 formatters test" do
    before do
      @format_class = ParameterSubstitution::Formatters::Md5
    end

    it "have a key" do
      expect(@format_class.key).to eq("md5")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Generates an md5 hash of the value.")
    end

    it "support converting different data types" do
      expect(@format_class.format("a string")).to eq("3a315533c0f34762e0c45e3d4e9d525c")
      expect(@format_class.format(1)).to eq("c4ca4238a0b923820dcc509a6f75849b")
      expect(@format_class.format(nil)).to eq("d41d8cd98f00b204e9800998ecf8427e")
    end
  end
end
