require_relative '../../../lib/parameter_substitution/parser'

describe ParameterSubstitution::Parser do
  def parser
    ParameterSubstitution::Parser.new
  end

  def assert_parse_output(text, expected)
    expect(parser.parse(text)).to eq(expected)
  end

  def assert_parsed_rule(sub_grammar, text, expected)
    expect(parser.send(sub_grammar).parse(text)).to eq(expected)
  rescue Parslet::ParseFailed => error
    fail error.parse_failure_cause.ascii_tree
  end

  def assert_rule_not_matched(sub_grammar, text)
    expect { parser.send(sub_grammar).parse(text) }.to raise_exception(::Parslet::ParseFailed)
  end

  context "Parser" do
    context "string_arg" do
      it "not recognize an unquoted string" do
        assert_rule_not_matched :string_arg, "not_quoted"
      end

      it "recognize a quoted string" do
        assert_parsed_rule :string_arg, '"A quoted string"', string_arg: "A quoted string"
        assert_parsed_rule :string_arg, "'A quoted string'", string_arg: "A quoted string"
      end

      it "recognize a quoted string with nested quotes" do
        # Tokenizer special case: slash characters are preserved.
        assert_parsed_rule :string_arg, '"A \"nested quoted\" string"', string_arg: "A \\\"nested quoted\\\" string"
      end

      it "recognize an empty string" do
        # Tokenizer special case: empty string arguments are an empty array.
        assert_parsed_rule :string_arg, '""', string_arg: []
      end
    end

    it "recognize simple integers" do
      assert_parsed_rule :int_arg, "0", int_arg: "0"
      assert_parsed_rule :int_arg, "1231", int_arg: "1231"
      assert_rule_not_matched :int_arg, "not a number"
    end

    context "argument list" do
      it "recognize a single parameter" do
        assert_parsed_rule :argument_list, "(1)", { :arg_list=>[{:int_arg=>"1"}] }
      end

      it "recognize a list of parameters" do
        assert_parsed_rule :argument_list, "()", { :arg_list=>[] }
      end

      it "recognize different types of arguments" do
        assert_parsed_rule :argument_list, "(\"abc\")", { :arg_list=>[{ :string_arg => "abc" }] }
        assert_parsed_rule :argument_list, "(1)", { :arg_list=>[{ :int_arg => "1" }] }
        assert_parsed_rule :argument_list, "(nil)", { :arg_list=>[{ :nil_arg => "nil" }] }
        assert_parsed_rule :argument_list, "(1.5)", { :arg_list=>[{ :float_arg => "1.5" }] }
      end
    end

    context "parameter parsing" do
      it "recognize a single raw parameter" do
        assert_parsed_rule :parameter,
                           "substitution_parameter",
                           { parameter_name: "substitution_parameter", method_calls: []}
      end

      it "recognize empty parens" do
        assert_parsed_rule :parameter,
                           "substitution_parameter.downcase()",
                           { parameter_name: "substitution_parameter", method_calls: [{method_call: "downcase", :arg_list=>[]}]}
      end

      it "recognize a parameter with a method_call" do
        assert_parsed_rule :parameter,
                           "substitution_parameter.method_call",
                           { parameter_name: "substitution_parameter", method_calls: [{method_call: "method_call"}]}
      end

      it "recognize a parameter with a method_call and arguments" do
        assert_parsed_rule :parameter,
                           "substitution_parameter.method_call(123,\"abc\")",
                           { parameter_name: "substitution_parameter",
                             method_calls: [{
                                              method_call: "method_call",
                                              :arg_list=>[{:int_arg=>"123"}, {:string_arg=>"abc"}]
                                            }]
                           }
      end

      it "allow unescaped spaces in the parameter name" do
        assert_parsed_rule :parameter,
                           "substitution parameter",
                           { parameter_name: "substitution parameter",
                             method_calls: []
                           }

        assert_parsed_rule :parameter,
                           "substitution parameter.method_call(123,\"abc\")",
                           { parameter_name: "substitution parameter",
                             method_calls: [{
                                              method_call: "method_call",
                                              :arg_list=>[{:int_arg=>"123"}, {:string_arg=>"abc"}]
                                            }]
                           }

      end

      it "allow escaping in the parameter name" do
        # Escaping slashes gets hard to read, so being verbose in favor of clarity.
        slash = "\\"

        assert_parsed_rule :parameter,
                           "this#{slash}<as#{slash}>#{slash}.embedded",
                           { parameter_name: "this\\<as\\>\\.embedded",
                             method_calls: []
                           }
      end


      it "recognize a nil parameter" do
        assert_parsed_rule :parameter,
                           "substitution_parameter.method_call(nil)",
                           { parameter_name: "substitution_parameter",
                             method_calls: [{
                                              method_call: "method_call",
                                              :arg_list=>[{:nil_arg=>"nil"}]
                                            }]
                           }
      end

      it "handle spaces in different places in the method_calls" do
        [
          "substitution_parameter.method_call(123,\"abc\")",
          "substitution_parameter.method_call(   123,\"abc\")",
          "substitution_parameter.method_call(   123,   \"abc\"   )",
        ].each do |input|
          assert_parsed_rule :parameter,
                             input,
                             { parameter_name: "substitution_parameter",
                               method_calls: [{
                                                method_call: "method_call",
                                                :arg_list=>[{:int_arg=>"123"}, {:string_arg=>"abc"}]
                                              }]
                             }
        end
      end
    end

    context "full expression testing" do
      it "match simple text" do
        assert_parse_output "simple_text", expression: [{text: "simple_text"}]
      end

      it "match a raw parameter" do
        assert_parse_output "<substitution_parameter>", expression: [{parameter_name: "substitution_parameter", method_calls: []}]
      end

      it "match a parameter with a single method_call" do
        assert_parse_output "<substitution_parameter.method_call>",
                            expression: [{parameter_name: "substitution_parameter", method_calls: [{ method_call: "method_call"}]}]
      end

      it "match a parameter with a multiple method_calls" do
        expected = {
          expression: [
                        {
                          parameter_name: "substitution_parameter",
                          method_calls: [ {method_call: "method_call1"}, {method_call: "method_call2"} ]
                        }
                      ]
        }

        assert_parse_output "<substitution_parameter.method_call1.method_call2>", expected
      end

      it "match a mix of text and parameters" do
        assert_parse_output "a<b>c<d><e>f", :expression =>[
          { text: "a" },
          { parameter_name: "b", method_calls: [] },
          { text: "c" },
          { parameter_name: "d", method_calls: [] },
          { parameter_name: "e", method_calls: [] },
          { text: "f" }]
      end

      it "handle a complicated case with multiple method_calls and arguments" do
        assert_parse_output "preamble<substitution_param.method_call1(\"arg1\", 123).method_call2>postamble",
                            expression: [
                                          { text: "preamble"},
                                          { parameter_name: "substitution_param",
                                            method_calls: [
                                                              { method_call: "method_call1", arg_list: [{string_arg: "arg1"}, {int_arg: "123"}]},
                                                              { method_call: "method_call2"}]},
                                          { text: "postamble"}]
      end

      it "handle a method_call with a substitution param as an argument" do
        assert_parse_output "preamble<substitution_param.method_call(<substitution_arg>)>postamble",
                            expression: [
                                          { text: "preamble" },
                                          { parameter_name: "substitution_param",
                                            method_calls:   [
                                                              { method_call: "method_call", arg_list: [
                                                                { raw_expression: [
                                                                                    { parameter_name: "substitution_arg",
                                                                                      method_calls: [] }
                                                                                  ] }
                                                              ] }
                                                            ] },
                                          { text: "postamble" }
                                        ]
      end

      it "handle a method_call with a substitution param and method call as an argument" do
        assert_parse_output "preamble<substitution_param.method_call1(<substitution_arg.method_call2>)>postamble",
                            expression: [
                                          { text: "preamble" },
                                          { parameter_name: "substitution_param",
                                            method_calls:   [
                                                              { method_call: "method_call1", arg_list: [
                                                                { raw_expression: [
                                                                                    { parameter_name: "substitution_arg",
                                                                                      method_calls: [
                                                                                                        { method_call: "method_call2" }
                                                                                                      ] }
                                                                                  ] }
                                                              ] }
                                                            ] },
                                          { text: "postamble" }
                                        ]
      end

      it "handle a method_call with a substitution param and method call and argument as an argument" do
        assert_parse_output "preamble<substitution_param.method_call1(<substitution_arg.method_call2(\"string_arg\")>)>postamble",
                            expression: [
                                          { text: "preamble" },
                                          { parameter_name: "substitution_param",
                                            method_calls:   [
                                                              { method_call: "method_call1", arg_list: [
                                                                { raw_expression: [
                                                                                    { parameter_name: "substitution_arg",
                                                                                      method_calls: [
                                                                                                        { method_call: "method_call2",
                                                                                                          arg_list: [{ string_arg: "string_arg" }] }
                                                                                                      ] }
                                                                                  ] }
                                                              ] }
                                                            ] },
                                          { text: "postamble" }
                                        ]
      end

      it "allow the parameter_start and parameter_end to be specified" do
        parser = ParameterSubstitution::Parser.new(parameter_start: "[", parameter_end: "]")

        expected = {
          expression: [
                        { text: "preamble"},
                        { parameter_name: "substitution_param",
                          method_calls: [
                                            { method_call: "method_call1", arg_list: [{string_arg: "arg1"}, {int_arg: "123"}]},
                                            { method_call: "method_call2"}]},
                        { text: "postamble"}]
        }

        expect(parser.parse("preamble[substitution_param.method_call1(\"arg1\", 123).method_call2]postamble")).to eq(expected)
      end

      it "raise if we do not receive an open or closing param" do
        parser = ParameterSubstitution::Parser.new

        expect { parser.parse("no opening bracket>") }.to raise_exception(Parslet::ParseFailed, /Extra input/)
      end
    end
  end
end
