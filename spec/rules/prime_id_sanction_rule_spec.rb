# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/builders/fund_load_builder'
require_relative '../../lib/repositories/in_memory_fund_load_repository'
require_relative '../../lib/rules/prime_id_sanction_rule'

RSpec.describe Rules::PrimeIdSanctionRule do
  let(:builder) { Builders::FundLoadBuilder }
  let(:repo) { Repositories::InMemoryFundLoadRepository.new }
  let(:rule) { described_class.new(fund_load_repository: repo) }
  let(:date) { '2025-09-03T10:00:00Z' }

  def add_load(id:, customer_id: '10', amount: '1.00$', timestamp: date, accepted: true)
    load = builder.build(id: id, customer_id: customer_id, amount: amount, timestamp: timestamp, accepted:)
    repo.add(load)
  end

  it 'passes for non-prime id regardless of other primes' do
    add_load(id: '2')
    cand = builder.build(id: '8', customer_id: '10', amount: '99999.00$', timestamp: date, accepted: true)
    # non-prime: rule does not constrain amount
    expect(rule.acceptable?(cand)).to be true
  end

  it 'fails for prime id with amount > 9999' do
    cand = builder.build(id: '3', customer_id: '10', amount: '10000.00$', timestamp: date, accepted: true)
    expect(rule.acceptable?(cand)).to be false
  end

  it 'allows only one prime id per date globally' do
    add_load(id: '3', customer_id: '11')
    cand = builder.build(id: '5', customer_id: '10', amount: '1.00$', timestamp: date, accepted: true)
    expect(rule.acceptable?(cand)).to be false
  end

  it 'allows a single prime id on that date' do
    cand = builder.build(id: '5', customer_id: '10', amount: '9.00$', timestamp: date, accepted: true)
    expect(rule.acceptable?(cand)).to be true
  end
end
