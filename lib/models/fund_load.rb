# frozen_string_literal: true

require 'dry-struct'
require 'dry/types'

module Types
  # Project-wide Dry::Types namespace used across models
  include Dry::Types()
end

module Models
  # Immutable value object for a fund load record.
  #
  # Attributes
  # - id [Integer] external load id from input
  # - customer_id [Integer]
  # - load_amount [Float] amount in dollars (e.g., 3318.47)
  # - effective_load_amount [Float] normalized/effective amount in dollars (defaults to load_amount)
  # - time [Time] UTC time the load occurred
  # - accepted [Boolean, nil] adjudication result when applicable
  class FundLoad < Dry::Struct
    # External id from input line
    attribute :id, Types::Integer
    attribute :customer_id, Types::String
    attribute :load_amount, Types::Float
    # Effective amount after normalization passes (in cents)
    attribute :effective_load_amount, Types::Float
    # UTC time the load occurred
    attribute :time, Types::Instance(Time)
    attribute? :accepted, Types::Bool.optional
  end
end
