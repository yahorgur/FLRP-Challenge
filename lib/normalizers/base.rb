# frozen_string_literal: true

module Normalizers
  # Base normalizer: stateless, idempotent transformation of FundLoad
  # @abstract
  class Base
    # @param load [Models::FundLoad]
    # @param load_builder [Builders::FundLoadBuilder]
    def call(load, load_builder)
      raise NotImplementedError
    end
  end
end
