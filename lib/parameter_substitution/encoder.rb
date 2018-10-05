# frozen_string_literal: true

require 'json'
require 'active_support/core_ext/string/inflections'
require 'builder'

class ParameterSubstitution
  class Encoder
    ENCODINGS = {
      cgi:             "CGI encode - for html parameters",
      html:            "HTML encode - for html content",
      xml:             "XML encode",
      angle_brackets:  "Content converted to a string and placed in angle brackets",
      json:            "JSON encode",
      raw:             "content is not changed",
      text:            "content is converted to a string"
    }.keys

    class << self
      def encode(value, destination_encoding, source_encoding, parameter_name, inside_quotes)
        destination_encoding.in?(ENCODINGS) or raise "unknown encoding #{destination_encoding}"
        source_encoding.in?(ENCODINGS) or raise "unknown encoding #{source_encoding}"

        result =
          if source_encoding == destination_encoding
            if destination_encoding == :json && inside_quotes
              value.to_json
            else
              value
            end
          else
            case destination_encoding
            when :cgi
              CGI.escape(value.to_s)
            when :html
              CGI.escapeHTML(value.to_s)
            when :xml
              value_for_xml(parameter_name, value)
            when :angle_brackets
              "<#{value}>"
            when :json
              value.to_json
            when :raw
              value
            when :text
              value.to_s
            else
              raise "unexepected escaping #{destination_encoding}"
            end
          end

        if destination_encoding == :json && inside_quotes
          if value.is_a?(String)
            result[1...-1]
          else
            result.to_json[1...-1]
          end
        else
          result
        end
      end

      private

      def value_for_xml(key, value)
        if value.is_a?(Array)
          array_to_xml(key, value)
        else
          CGI.escapeHTML(value.to_s)
        end
      end

      def array_to_xml(key, value)
        tag_name = key_to_tag_name(key)
        buffer = +""
        builder = Builder::XmlMarkup.new(target: buffer)
        value.each { |tag_value| builder.tag!(tag_name, tag_value) }
        buffer
      end

      def key_to_tag_name(key)
        key.gsub('ids_', 'id_').singularize
      end
    end
  end
end
