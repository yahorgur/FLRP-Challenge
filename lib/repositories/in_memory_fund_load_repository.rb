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

    # Return all accepted records.
    # @return [Repositories::InMemoryFundLoadRepository]
    def accepted
      self.class.new(records.select(&:accepted))
    end

    # Return all records matching the given customer id.
    # @param customer_id [Integer, String]
    # @return [Repositories::InMemoryFundLoadRepository]
    def find_by_customer_id(customer_id)
      self.class.new(records.select { |r| r.customer_id == customer_id })
    end

    # Return all records for the given calendar date.
    # @param date [Date, DateTime]
    # @return [Repositories::InMemoryFundLoadRepository]
    def find_by_date(date)
      d = date.to_date
      self.class.new(records.select { |r| r.time.utc.to_date == d })
    end

    # Return the record matching the given transaction id.
    # @param id [Integer, String]
    # @return [Models::FundLoad, nil]
    def find_by_id(id)
      tid = Integer(id)
      records.detect { |r| r.id == tid }
    rescue ArgumentError, TypeError
      nil
    end
  end
end
