# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/builders/fund_load_builder'

RSpec.describe Builders::FundLoadBuilder do
  let(:attrs) do
    {
      id: '1',
      customer_id: '123',
      amount: '1,234.50$',
      timestamp: '2025-09-03T10:15:00Z'
    }
  end

  it 'builds a valid FundLoad' do
    record = described_class.build(attrs)
    expect(record).to be_a(Models::FundLoad)
    expect(record.id).to eq(1)
    expect(record.customer_id).to eq(123)
    expect(record.amount).to eq(1234.5)
    expect(record.timestamp).to be_a(DateTime)
  end

  it 'raises on missing fields' do
    %i[id customer_id amount timestamp].each do |key|
      bad = attrs.dup
      bad[key] = nil
      expect { described_class.build(bad) }.to raise_error(ArgumentError)
    end
  end

  it 'raises on malformed fields' do
    expect { described_class.build(attrs.merge(id: 'x')) }.to raise_error(ArgumentError)
    expect { described_class.build(attrs.merge(customer_id: 'x')) }.to raise_error(ArgumentError)
    expect { described_class.build(attrs.merge(amount: 'abc$')) }.to raise_error(ArgumentError)
    expect { described_class.build(attrs.merge(timestamp: 'not-a-date')) }.to raise_error(ArgumentError)
  end
end
