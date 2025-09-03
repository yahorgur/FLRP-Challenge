# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/rules/base'

RSpec.describe Rules::Base do
  it 'keeps acceptable? abstract' do
    klass = Class.new(described_class)
    expect { klass.new(fund_load_repository: double).acceptable?(nil) }.to raise_error(NotImplementedError)
  end
end
