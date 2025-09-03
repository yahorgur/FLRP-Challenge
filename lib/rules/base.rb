# frozen_string_literal: true

module Rules
  # Abstract rule: evaluates candidate against repository
  class Base
    # @param accepted_repo [Repositories::FundLoadRepository]
    def initialize(fund_load_repository:)
      @fund_load_repository = fund_load_repository
    end

    # @param candidate [Models::FundLoad]
    # @return [Boolean]
    def acceptable?(_candidate)
      raise NotImplementedError
    end

    private

    attr_reader :fund_load_repository
  end
end
