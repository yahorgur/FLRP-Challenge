# frozen_string_literal: true

require_relative 'base'

module Normalizers
  class MondayAmountNormalizer < Base
    # @param load [Models::FundLoad]
    # @return Models::FundLoad
    def call(load, load_builder)
      return load unless load.timestamp.monday?

      load_builder.build(load.to_h.merge(effective_amount: load.amount * 2.0))
    end
  end
end
