# frozen_string_literal: true

require_relative '../../../../lib/parameter_substitution/formatters/string_to_base64'

describe ParameterSubstitution::Formatters::StringToBase64 do
  context "StringToBase64 formatter test" do
    before do
      @format_class = ParameterSubstitution::Formatters::StringToBase64
    end

    it "have a key" do
      expect(@format_class.key).to eq("string_to_base64")
    end

    it "provide a description" do
      expect(@format_class.description).to eq("Converts strings to base64 encoding")
    end

    it "converts to base64" do
      # sha256 original value: TestValue:5678
      expect(@format_class.format("TestValue:5678")).to eq("VGVzdFZhbHVlOjU2Nzg=")
    end

    it "converts 80+ character string to base64 without newline character" do
      # sha256 original value: cMwwWi7qNY3HdknYjir5H2kovw1RFIlelpznZs59K3sHZCDNgvzF5hgiPI0c3LF8NJH0b3W116A9mrnk50
      expect(@format_class.format("cMwwWi7qNY3HdknYjir5H2kovw1RFIlelpznZs59K3sHZCDNgvzF5hgiPI0c3LF8NJH0b3W116A9mrnk50")). to eq("Y013d1dpN3FOWTNIZGtuWWppcjVIMmtvdncxUkZJbGVscHpuWnM1OUszc0haQ0ROZ3Z6RjVoZ2lQSTBjM0xGOE5KSDBiM1cxMTZBOW1ybms1MA==")
      expect('Y01vd3dXaTdxTlkzSGRrbllqaXI1SDJrb3Z3MVJGSWxlbHB6blpzNTlLM3NHWkNETmd2ekY1aGdpUEkwYzNMRjhOSkgwYjNXMTE2QTltcm5rNTA='.unpack("m0").first.unpack('H*').first).to eq('634d6f7777576937714e593348646b6e596a69723548326b6f7677315246496c656c707a6e5a7335394b3373475a43444e67767a463568676950493063334c46384e4a483062335731313641396d726e6b3530')
    end

    it "handles nil input" do
      expect(@format_class.format(nil)).to eq(nil)
    end
  end
end