# frozen_string_literal: true

require_relative '../models/fund_load'

module Repositories
  # Abstract repository for accessing FundLoad records
  class FundLoadRepository
    attr_reader :records

    # Initialize repository with an optional array of records.
    #
    # Params:
    # - records: Array<Models::FundLoad>
    def initialize(records = [])
      @records = Array(records)
    end

    # Find all accepted records.
    #
    # Returns: Array<Models::FundLoad>
    def accepted
      raise NotImplementedError, 'Implement in subclass'
    end

    # Find all records by customer identifier.
    #
    # Params:
    # - customer_id: Integer
    #
    # Returns: Array<Models::FundLoad>
    def find_by_customer_id(_customer_id)
      raise NotImplementedError, 'Implement in subclass'
    end

    # Find all records for a given calendar date.
    #
    # Params:
    # - date: Date or DateTime
    #
    # Returns: Array<Models::FundLoad>
    def find_by_date(_date)
      raise NotImplementedError, 'Implement in subclass'
    end

    # Find a record by transaction id.
    #
    # Params:
    # - id: Integer
    #
    # Returns: Models::FundLoad or nil when not found
    def find_by_transaction_id(_id)
      raise NotImplementedError, 'Implement in subclass'
    end
  end
end
