# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/builders/fund_load_builder'

RSpec.describe Builders::FundLoadBuilder do
  let(:attrs) do
    {
      'id' => '15887',
      'customer_id' => '528',
      'load_amount' => '$3,318.47',
      'time' => '2000-01-01T00:00:00Z'
    }
  end

  it 'builds a valid FundLoad' do
    record = described_class.build(attrs)
    expect(record).to be_a(Models::FundLoad)
    expect(record.id).to eq(15_887)
    expect(record.customer_id).to eq('528')
    expect(record.load_amount).to eq(3_318.47)
    expect(record.effective_load_amount).to eq(3_318.47)
    expect(record.time).to eq(Time.utc(2000, 1, 1, 0, 0, 0))
  end

  it 'raises on malformed fields' do
    expect { described_class.build(attrs.merge('load_amount' => 'abc$')) }.to raise_error(ArgumentError)
    expect { described_class.build(attrs.merge('time' => 'not-a-date')) }.to raise_error(ArgumentError)
  end
end
