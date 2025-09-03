# frozen_string_literal: true

require 'date'
require_relative '../models/fund_load'

module Builders
  # Builds validated FundLoad instances from untyped input
  class FundLoadBuilder
    class << self
      # Build a Models::FundLoad from untyped attributes.
      #
      # Params:
      # - attrs: Hash with keys :id, :customer_id, :amount, :timestamp
      #   - id: Integer or String numeric
      #   - customer_id: Integer or String numeric
      #   - amount: String like "99.99$" or "1,234.56$" (commas/$ allowed)
      #   - timestamp: String; ISO8601 preferred, falls back to DateTime.parse
      #
      # Returns: Models::FundLoad
      # Raises: ArgumentError when required fields are missing or malformed
      def build(attrs)
        validate_presence!(attrs)

        Models::FundLoad.new(
          id: to_integer(attrs[:id]),
          customer_id: to_integer(attrs[:customer_id]),
          amount: parse_amount(attrs[:amount]),
          timestamp: parse_timestamp(attrs[:timestamp])
        )
      end

      private

      # Validate presence of all required fields.
      #
      # Params:
      # - attrs: Hash of input attributes
      #
      # Raises: ArgumentError when any required field is blank
      def validate_presence!(attrs)
        %i[id customer_id amount timestamp].each do |key|
          value = attrs[key]
          next unless value.nil? || blank_string?(value)

          raise ArgumentError, "Missing required field: #{key}"
        end
      end

      # Check if a value is a blank string (only whitespace).
      #
      # Params:
      # - value: Any
      #
      # Returns: Boolean
      def blank_string?(value)
        value.respond_to?(:strip) && value.strip.empty?
      end

      # Convert value to Integer.
      #
      # Params:
      # - value: Integer or String numeric
      #
      # Returns: Integer
      # Raises: ArgumentError on invalid numeric
      def to_integer(value)
        Integer(value)
      rescue ArgumentError, TypeError
        raise ArgumentError, "Invalid integer: #{value.inspect}"
      end

      # Parse a currency-like string to Float amount.
      #
      # Params:
      # - value: String or numeric; '$' and ',' are ignored
      #
      # Returns: Float
      # Raises: ArgumentError on invalid format
      def parse_amount(value)
        cleaned = value.to_s.delete(',').delete('$')
        Float(cleaned)
      rescue ArgumentError, TypeError
        raise ArgumentError, "Invalid amount: #{value.inspect}"
      end

      # Parse a timestamp string to DateTime.
      # Prefers ISO8601; falls back to DateTime.parse.
      #
      # Params:
      # - value: String timestamp
      #
      # Returns: DateTime
      # Raises: ArgumentError on invalid format
      def parse_timestamp(value)
        str = value.to_s
        begin
          DateTime.iso8601(str)
        rescue ArgumentError
          DateTime.parse(str)
        end
      rescue ArgumentError, TypeError
        raise ArgumentError, "Invalid timestamp: #{value.inspect}"
      end
    end
  end
end
