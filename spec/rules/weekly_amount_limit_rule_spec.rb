# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/builders/fund_load_builder'
require_relative '../../lib/normalizers/monday_amount_normalizer'
require_relative '../../lib/repositories/in_memory_fund_load_repository'
require_relative '../../lib/rules/weekly_amount_limit_rule'

RSpec.describe Rules::WeeklyAmountLimitRule do
  let(:builder) { Builders::FundLoadBuilder }
  let(:repo) { Repositories::InMemoryFundLoadRepository.new }
  let(:rule) { described_class.new(fund_load_repository: repo) }

  def add_load(id:, amount:, time:, customer_id: '10', accepted: true)
    load = builder.build(id:, customer_id:, load_amount: amount, time:, accepted:)
    repo.add(load)
  end

  it 'passes at exactly 20000 effective within same ISO week' do
    add_load(id: '1', amount: '$10000.00', time: '2025-09-02T10:00:00Z') # Tue
    add_load(id: '2', amount: '$10000.00', time: '2025-09-03T10:00:00Z') # Wed
    cand = builder.build(id: '9', customer_id: '10', load_amount: '$0.00', time: '2025-09-04T10:00:00Z', accepted: true)
    expect(rule.acceptable?(cand)).to be true
  end

  it 'fails when over 20000 in same ISO week' do
    add_load(id: '1', amount: '$10000.01', time: '2025-09-02T10:00:00Z')
    add_load(id: '2', amount: '$10000.00', time: '2025-09-03T10:00:00Z')
    cand = builder.build(id: '9', customer_id: '10', load_amount: '$0.00', time: '2025-09-04T10:00:00Z', accepted: true)
    expect(rule.acceptable?(cand)).to be false
  end

  it 'resets across ISO week boundary' do
    add_load(id: '1', amount: '$15000.00', time: '2025-09-07T10:00:00Z') # Sunday
    cand = builder.build(
      id: '9',
      customer_id: '10',
      load_amount: '$10000.00',
      time: '2025-09-08T10:00:00Z',
      accepted: true
    ) # Monday
    expect(rule.acceptable?(cand)).to be true
  end
end
