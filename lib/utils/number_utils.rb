# frozen_string_literal: true

module Utils
  # Number helpers
  module NumberUtils
    # Fast deterministic prime test for reasonable integer range
    # @param num [Integer]
    # @return [Boolean]
    def self.prime?(num)
      begin
        n = Integer(num)
      rescue ArgumentError, TypeError
        return false
      end
      return false if n <= 1

      return true if n == 2

      return false if (n % 2).zero?

      i = 3
      while i * i <= n
        return false if (n % i).zero?

        i += 2
      end
      true
    end
  end
end
