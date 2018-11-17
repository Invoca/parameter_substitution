# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/parse_time'

describe ParameterSubstitution::Formatters::ParseTime do
  context "Parse time formatters test" do
    before do
      @format_class = ParameterSubstitution::Formatters::ParseTime
    end

    it "have a key" do
      expect(@format_class.key).to eq("parse_time")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Takes format_string as a parameter and uses format_string to parse the input as a time. Does not change the input if the value is not a time.")
    end

    it "support converting times" do
      expect(@format_class.new("%y-%m-%d-%H-%M-%S").format("01-02-03-04-05-06")).to eq("2001-02-03 04:05:06")
      expect(@format_class.new("%S-%M-%H-%d-%m-%y").format("01-02-03-04-05-06")).to eq("2006-05-04 03:02:01")
      expect(@format_class.new("%y-%m-%d-%H-%M-%S").format("not a real date time")).to eq("not a real date time")
      expect(@format_class.new("%y-%m-%d-%H-%M-%S").format(nil)).to eq(nil)
    end
  end
end
