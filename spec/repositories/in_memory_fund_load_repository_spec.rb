# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/builders/fund_load_builder'
require_relative '../../lib/repositories/in_memory_fund_load_repository'

RSpec.describe Repositories::InMemoryFundLoadRepository do
  let(:builder) { Builders::FundLoadBuilder }
  let(:r1) { builder.build(id: '1', customer_id: '10', amount: '100.00$', timestamp: '2025-09-03T01:00:00Z') }
  let(:r2) { builder.build(id: '2', customer_id: '10', amount: '50.00$', timestamp: '2025-09-03T23:59:59Z') }
  let(:r3) { builder.build(id: '3', customer_id: '11', amount: '75.00$', timestamp: '2025-09-04T00:00:00Z') }

  subject(:repo) { described_class.new([r1, r2, r3]) }

  it 'finds by customer_id' do
    results = repo.find_by_customer_id(10)
    expect(results.map(&:id)).to contain_exactly(1, 2)
  end

  it 'finds by date (calendar day)' do
    results = repo.find_by_date(Date.new(2025, 9, 3))
    expect(results.map(&:id)).to contain_exactly(1, 2)
  end

  it 'finds by transaction id' do
    expect(repo.find_by_transaction_id(1)&.id).to eq(1)
    expect(repo.find_by_transaction_id(999)).to be_nil
  end

  it 'adds a record with #add' do
    new_record = builder.build(id: '4', customer_id: '12', amount: '5.00$', timestamp: '2025-09-05T12:00:00Z')
    repo.add(new_record)
    expect(repo.find_by_transaction_id(4)).to eq(new_record)
  end
end
