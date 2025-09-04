# frozen_string_literal: true

require_relative 'base'

module Rules
  # Max 3 accepted loads per customer per calendar date
  class DailyLoadCountRule < Base
    LIMIT = 3
    # @param candidate [Models::FundLoad]
    # @return [Boolean]
    def acceptable?(candidate)
      same_day = fund_load_repository
                 .accepted
                 .find_by_date(candidate.time)
                 .find_by_customer_id(candidate.customer_id)
                 .records
      (same_day.count + 1) <= LIMIT
    end
  end
end
