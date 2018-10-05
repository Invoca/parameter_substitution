# frozen_string_literal: true

require 'parslet'
#
# The parser describes the rules of the grammar, and when executed on a string it will
# either fail with an exception or it will return a structure describing what it found.
#
# See the parslet documentation for more detail.
#

class ParameterSubstitution
  class Parser < Parslet::Parser
    def initialize(parameter_start: "<", parameter_end: ">", allow_unmatched_parameter_end: false)
      @parameter_start = parameter_start
      @parameter_end = parameter_end
      @allow_unmatched_parameter_end = allow_unmatched_parameter_end
      super()
    end

    root :text_with_substitution_parameters

    rule(:double_quote)    { str("\"")             }
    rule(:single_quote)    { str("\'")             }
    rule(:escape)          { str("\\")             }
    rule(:dot)             { str(".")              }
    rule(:open_param)      { str(@parameter_start) }
    rule(:close_param)     { str(@parameter_end)   }
    rule(:digit)           { match["0-9"]          }
    rule(:parameter_start) { str("(")              }
    rule(:parameter_end)   { str(")")              }
    rule(:space)           { str(" ")              }
    rule(:space?)          { space.repeat          }
    rule(:comma)           { space? >> str(",") >> space? }

    rule :double_quoted_string_arg do
      double_quote >> (escape >> any | double_quote.absent? >> any).repeat.as(:string_arg) >> double_quote
    end

    rule :single_quoted_string_arg do
      single_quote >> (escape >> any | single_quote.absent? >> any).repeat.as(:string_arg) >> single_quote
    end

    rule :string_arg do
      double_quoted_string_arg | single_quoted_string_arg
    end

    rule :float_arg do
      (digit.repeat(1) >> dot >> digit.repeat(1)).as(:float_arg)
    end

    rule :int_arg do
      digit.repeat(1).as(:int_arg)
    end

    rule :nil_arg do
      str('nil').as(:nil_arg)
    end

    rule :substitution_parameter_arg do
      open_param >> parameter.repeat.as(:raw_expression) >> close_param
    end

    rule :arg do
      float_arg | string_arg | int_arg | nil_arg | substitution_parameter_arg
    end

    rule :argument_list do
      parameter_start >> space? >> (arg >> (comma >> arg).repeat).repeat(0, 1).as(:arg_list) >> space? >> parameter_end
    end

    rule :method_name do
      (parameter_start.absent? >> close_param.absent? >> dot.absent? >> any).repeat(1).as(:method_call)
    end

    rule :method_call do
      method_name >> argument_list.maybe
    end

    rule :method_call_list do
      (dot >> method_call).repeat(0)
    end

    rule :parameter_name do
      ((escape >> any) | (open_param.absent? >> close_param.absent? >> dot.absent? >> any)).repeat(1)
    end

    rule :parameter do
      parameter_name.as(:parameter_name) >> method_call_list.as(:method_calls)
    end

    rule :substitution_parameter_with_brackets do
      open_param >> parameter >> close_param
    end

    rule :text do
      text_char =
        if @allow_unmatched_parameter_end
          (open_param.absent? >> any)
        else
          (open_param.absent? >> close_param.absent? >> any)
        end
      text_char.repeat(1).as(:text)
    end

    rule :text_with_substitution_parameters do
      (text | substitution_parameter_with_brackets).repeat.as(:expression)
    end
  end
end
