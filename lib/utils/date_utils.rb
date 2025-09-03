# frozen_string_literal: true

module Utils
  # Date helpers
  module DateUtils
    # Compare two times by ISO week bucket
    # @param a [Time,DateTime]
    # @param b [Time,DateTime]
    # @return [Boolean]
    def self.same_iso_week?(time_a, time_b)
      time_a.strftime('%G-W%V') == time_b.strftime('%G-W%V')
    end
  end
end
