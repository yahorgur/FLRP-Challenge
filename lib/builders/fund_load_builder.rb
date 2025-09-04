# frozen_string_literal: true

require 'date'
require 'bigdecimal'
require_relative '../models/fund_load'

module Builders
  # Builds validated FundLoad instances from untyped input
  class FundLoadBuilder
    class << self
      # Clone a Models::FundLoad with overrides.
      # @param load [Models::FundLoad]
      # @param overrides [Hash]
      # @return [Models::FundLoad]
      def clone(load, overrides = {})
        Models::FundLoad.new(load.to_h.merge(overrides))
      end

      # Build a Models::FundLoad from untyped attributes.
      #
      # Params:
      # - attrs: Hash with keys 'id', 'customer_id', 'load_amount', 'time'
      #   - id [String, Integer]
      #   - customer_id [String, Integer]
      #   - load_amount [String, Float] like "$3,318.47" (commas/$ allowed)
      #   - time [String, Time] ISO8601 or Time
      #
      # @return [Models::FundLoad]
      # @raise [ArgumentError] when required fields are missing or malformed
      def build(attrs)
        attrs = symbolize_string_keys(attrs)

        parsed_load_amount = parse_load_amount(attrs[:load_amount])

        Models::FundLoad.new(
          id: attrs[:id].to_i,
          customer_id: attrs[:customer_id].to_i,
          load_amount: parsed_load_amount,
          time: parse_time(attrs[:time]),
          effective_load_amount: parsed_load_amount,
          accepted: attrs[:accepted]
        )
      end

      private

      # Parse load_amount into dollars as Float.
      # @param value [String]
      # @return [Float]
      # @raise [ArgumentError]
      def parse_load_amount(value)
        str = value.to_s.delete(',').delete('$').delete('USD').strip
        bd = BigDecimal(str)
        bd.to_f
      rescue StandardError
        raise ArgumentError, "Invalid load_amount: #{value.inspect}"
      end

      # Parse ISO8601 time into UTC Time.
      # @param value [String]
      # @return [Time]
      # @raise [ArgumentError]
      def parse_time(value)
        Time.iso8601(value).utc
      rescue StandardError
        raise ArgumentError, "Invalid time: #{value.inspect}"
      end

      # Normalize keys to symbols (lowercased).
      # @param attrs [Hash]
      # @return [Hash]
      def symbolize_string_keys(attrs)
        return attrs if attrs.is_a?(Hash) && attrs.keys.first.is_a?(Symbol)

        attrs.to_h.transform_keys { |k| k.to_s.downcase.to_sym }
      end
    end
  end
end
