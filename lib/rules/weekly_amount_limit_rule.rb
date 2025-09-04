# frozen_string_literal: true

require_relative 'base'
require_relative '../utils/date_utils'

module Rules
  # Max $20000 per customer per ISO week (based on effective_load_amount dollars)
  class WeeklyAmountLimitRule < Base
    LIMIT = 20_000.0

    # @param candidate [Models::FundLoad]
    # @return [Boolean]
    def acceptable?(candidate)
      # Filter accepted loads in same ISO week for this customer
      week = fund_load_repository.accepted.find_by_customer_id(candidate.customer_id).records
                                 .select { |r| Utils::DateUtils.same_iso_week?(r.time, candidate.time) }
      sum = week.sum(&:effective_load_amount)
      (sum + candidate.effective_load_amount) <= LIMIT
    end
  end
end
