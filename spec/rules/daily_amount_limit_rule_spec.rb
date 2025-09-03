# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/builders/fund_load_builder'
require_relative '../../lib/repositories/in_memory_fund_load_repository'
require_relative '../../lib/rules/daily_amount_limit_rule'

RSpec.describe Rules::DailyAmountLimitRule do
  let(:builder) { Builders::FundLoadBuilder }
  let(:repo) { Repositories::InMemoryFundLoadRepository.new }
  let(:rule) { described_class.new(fund_load_repository: repo) }
  let(:date) { '2025-09-01T10:00:00Z' } # Monday to test doubling

  def add_load(id:, amount:, customer_id: '10', timestamp: date, accepted: true)
    load = builder.build(id: id, customer_id: customer_id, amount: amount, timestamp: timestamp, accepted:)
    repo.add(load)
  end

  it 'passes at exactly 5000 effective' do
    add_load(id: '1', amount: '4000.00$')
    add_load(id: '2', amount: '999.99$')
    cand = builder.build(id: '9', customer_id: '10', amount: '0.01$', timestamp: date, accepted: true)
    expect(rule.acceptable?(cand)).to be true
  end

  it 'fails when over 5000 effective' do
    add_load(id: '1', amount: '4000.00$')
    add_load(id: '2', amount: '1000.00$')
    cand = builder.build(id: '9', customer_id: '10', amount: '0.01$', timestamp: date, accepted: true)
    expect(rule.acceptable?(cand)).to be false
  end
end
