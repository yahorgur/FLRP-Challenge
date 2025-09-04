# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/builders/fund_load_builder'
require_relative '../../lib/normalizers/monday_amount_normalizer'

RSpec.describe Normalizers::MondayAmountNormalizer do
  let(:builder) { Builders::FundLoadBuilder }
  let(:normalizer) { described_class.new }

  it 'keeps amount on non-Monday' do
    load = builder.build('id' => '1', 'customer_id' => '1', 'load_amount' => '$10.00', 'time' => '2025-09-03T10:00:00Z')
    out = normalizer.call(load, builder)
    expect(out.effective_load_amount).to eq(10.00)
  end

  it 'doubles once on Monday' do
    load = builder.build('id' => '2', 'customer_id' => '1', 'load_amount' => '$10.00', 'time' => '2025-09-01T10:00:00Z')
    out = normalizer.call(load, builder)
    expect(out.effective_load_amount).to eq(20.00)
  end
end
