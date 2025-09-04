# frozen_string_literal: true

require_relative 'base'

module Normalizers
  class MondayAmountNormalizer < Base
    # @param load [Models::FundLoad]
    # @param load_builder [Builders::FundLoadBuilder]
    # @return [Models::FundLoad]
    def call(load, load_builder)
      return load unless load.time.monday?

      load_builder.build(load.to_h.merge(effective_load_amount: load.effective_load_amount * 2.0))
    end
  end
end
