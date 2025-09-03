# frozen_string_literal: true

require 'dry-struct'
require 'dry/types'

module Types
  # Project-wide Dry::Types namespace used across models
  include Dry::Types()
end

module Models
  # Immutable value object for a fund load record
  class FundLoad < Dry::Struct
    attribute :id, Types::Integer
    attribute :customer_id, Types::Integer
    attribute :amount, Types::Float
    attribute :timestamp, Types::Params::DateTime
  end
end
