# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/builders/fund_load_builder'
require_relative '../../lib/repositories/in_memory_fund_load_repository'
require_relative '../../lib/rules/daily_load_count_rule'

RSpec.describe Rules::DailyLoadCountRule do
  let(:builder) { Builders::FundLoadBuilder }
  let(:repo) { Repositories::InMemoryFundLoadRepository.new }
  let(:rule) { described_class.new(fund_load_repository: repo) }
  let(:date) { '2025-09-03T10:00:00Z' }

  def add_load(id:, customer_id: '10', load_amount: '1.00$', time: date, accepted: true)
    load = builder.build(id: id, customer_id:, load_amount:, time:, accepted:)
    repo.add(load)
  end

  it 'passes for up to 2 prior accepted loads' do
    add_load(id: '1')
    add_load(id: '2')
    cand = builder.build(id: '9', customer_id: '10', load_amount: '1.00$', time: date, accepted: true)
    expect(rule.acceptable?(cand)).to be true
  end

  it 'fails when 3 prior accepted exist' do
    add_load(id: '1')
    add_load(id: '2')
    add_load(id: '3')
    cand = builder.build(id: '9', customer_id: '10', load_amount: '1.00$', time: date, accepted: true)
    expect(rule.acceptable?(cand)).to be false
  end

  it 'other customers do not affect count' do
    add_load(id: '1', customer_id: '11')
    add_load(id: '2', customer_id: '11')
    add_load(id: '3', customer_id: '11')
    cand = builder.build(id: '9', customer_id: '10', load_amount: '1.00$', time: date, accepted: true)
    expect(rule.acceptable?(cand)).to be true
  end
end
