# frozen_string_literal: true

require_relative 'base'

module Rules
  # Max $5000 per customer per calendar date (based on effective_load_amount dollars)
  class DailyAmountLimitRule < Base
    LIMIT = 5000.0

    # @param candidate [Models::FundLoad]
    # @return [Boolean]
    def acceptable?(candidate)
      sum = fund_load_repository
            .accepted
            .find_by_date(candidate.time)
            .find_by_customer_id(candidate.customer_id)
            .records
            .sum(&:effective_load_amount)
      (sum + candidate.effective_load_amount) <= LIMIT
    end
  end
end
