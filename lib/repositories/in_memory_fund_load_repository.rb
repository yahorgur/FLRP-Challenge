# frozen_string_literal: true

require_relative 'fund_load_repository'

module Repositories
  # In-memory implementation of FundLoadRepository
  class InMemoryFundLoadRepository < FundLoadRepository
    # Initialize with optional seed records.
    #
    # Params:
    # - records: Array<Models::FundLoad>
    def initialize(records = [])
      super
    end

    # Append a record to the in-memory store.
    #
    # Params:
    # - record: Models::FundLoad
    #
    # Returns: Models::FundLoad (the same record)
    def add(record)
      @records << record
      record
    end

    # Return all records matching the given customer id.
    #
    # Params:
    # - customer_id: Integer or String numeric
    #
    # Returns: Array<Models::FundLoad>
    def find_by_customer_id(customer_id)
      cid = Integer(customer_id)
      records.select { |r| r.customer_id == cid }
    end

    # Return all records for the given calendar date.
    #
    # Params:
    # - date: Date or DateTime
    #
    # Returns: Array<Models::FundLoad>
    def find_by_date(date)
      d = date.to_date
      records.select { |r| r.timestamp.to_date == d }
    end

    # Return the record matching the given transaction id.
    #
    # Params:
    # - id: Integer or String numeric
    #
    # Returns: Models::FundLoad or nil
    def find_by_transaction_id(id)
      tid = Integer(id)
      records.detect { |r| r.id == tid }
    rescue ArgumentError, TypeError
      nil
    end
  end
end
