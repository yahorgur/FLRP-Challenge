# frozen_string_literal: true

require_relative 'base'

module Rules
  # Max $5000 per customer per calendar date (effective_amount)
  class DailyAmountLimitRule < Base
    LIMIT = 5000.0

    # @param candidate [Models::FundLoad]
    # @return [Boolean]
    def acceptable?(candidate)
      same_day = fund_load_repository
                 .accepted
                 .find_by_date(candidate.timestamp)
                 .find_by_customer_id(candidate.customer_id)
                 .records
                 .sum(&:effective_amount)
      (same_day + candidate.effective_amount) <= LIMIT
    end
  end
end
