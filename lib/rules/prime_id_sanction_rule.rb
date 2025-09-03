# frozen_string_literal: true

require_relative 'base'
require_relative '../utils/number_utils'

module Rules
  # Sanction for prime transaction IDs (extra constraints)
  # - Candidate amount must be <= 9999
  # - Only one prime-id load per date globally
  class PrimeIdSanctionRule < Base
    # @param candidate [Models::FundLoad]
    # @return [Boolean]
    def acceptable?(candidate)
      return true unless Utils::NumberUtils.prime?(candidate.id)
      return false if candidate.amount > 9_999

      same_day = fund_load_repository.accepted.find_by_date(candidate.timestamp).records
      # Any accepted record with prime id blocks another on that date
      same_day.none? { |r| Utils::NumberUtils.prime?(r.id) }
    end
  end
end
