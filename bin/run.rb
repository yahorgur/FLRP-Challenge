#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'json'
ROOT = File.expand_path('..', __dir__)
$LOAD_PATH.unshift File.join(ROOT, 'lib') unless $LOAD_PATH.include?(File.join(ROOT, 'lib'))

require 'builders/fund_load_builder'
require 'repositories/in_memory_fund_load_repository'
require 'normalizers/monday_amount_normalizer'
require 'rules/daily_amount_limit_rule'
require 'rules/daily_load_count_rule'
require 'rules/weekly_amount_limit_rule'
require 'rules/prime_id_sanction_rule'

# Minimal in-file adapters to orchestrate normalizers and rules
module Pipeline
  class NormalizerRunner
    def initialize(normalizers, load_builder)
      @normalizers = Array(normalizers)
      @load_builder = load_builder
    end

    def run(load)
      @normalizers.inject(load) { |acc, normalizer| normalizer.call(acc, @load_builder) || acc }
    end
  end

  class RulesEngine
    def initialize(rules)
      @rules = Array(rules)
    end

    def accepted?(candidate)
      @rules.all? { |rule| rule.acceptable?(candidate) }
    end
  end
end

INPUT_PATH  = ENV.fetch('INPUT_PATH',  ARGV[0] || 'input.txt')
OUTPUT_PATH = ENV.fetch('OUTPUT_PATH', ARGV[1] || 'output.txt')

repo = Repositories::InMemoryFundLoadRepository.new
builder = Builders::FundLoadBuilder
normalizers = [Normalizers::MondayAmountNormalizer.new]
normalizer_runner = Pipeline::NormalizerRunner.new(normalizers, builder)
rules = [
  Rules::DailyAmountLimitRule.new(fund_load_repository: repo),
  Rules::DailyLoadCountRule.new(fund_load_repository: repo),
  Rules::WeeklyAmountLimitRule.new(fund_load_repository: repo),
  Rules::PrimeIdSanctionRule.new(fund_load_repository: repo)
]
rules_engine = Pipeline::RulesEngine.new(rules)

begin
  File.open(OUTPUT_PATH, 'w') do |out_io|
    File.foreach(INPUT_PATH, chomp: true) do |line|
      line = line.strip
      next if line.empty?

      begin
        attrs = JSON.parse(line)
        load = builder.build(attrs)
        normalized = normalizer_runner.run(load)
        accepted = rules_engine.accepted?(normalized)
        adjudicated = builder.clone(normalized, accepted:)
        repo.add(adjudicated)

        out = { id: adjudicated.id.to_s, customer_id: adjudicated.customer_id.to_s, accepted: accepted }
        out_io.puts(JSON.generate(out))
      rescue JSON::ParserError => e
        warn "[skip] invalid JSON: #{e.message}"
      rescue StandardError => e
        warn "[skip] #{e.class}: #{e.message}"
      end
    end
  end
rescue Errno::ENOENT => e
  warn "[error] #{e.message}"
  exit 1
end

exit 0
