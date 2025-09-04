# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/repositories/fund_load_repository'

RSpec.describe Repositories::FundLoadRepository do
  subject(:repo) { described_class.new }

  it 'raises for find_by_customer_id' do
    expect { repo.find_by_customer_id(1) }.to raise_error(NotImplementedError)
  end

  it 'raises for find_by_date' do
    expect { repo.find_by_date(Date.today) }.to raise_error(NotImplementedError)
  end

  it 'raises for find_by_id' do
    expect { repo.find_by_id(1) }.to raise_error(NotImplementedError)
  end
end
