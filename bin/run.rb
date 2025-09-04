#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'json'
ROOT = File.expand_path('..', __dir__)
$LOAD_PATH.unshift File.join(ROOT, 'lib') unless $LOAD_PATH.include?(File.join(ROOT, 'lib'))

require 'builders/fund_load_builder'
require 'repositories/in_memory_fund_load_repository'

INPUT_PATH = File.join(ROOT, 'input.txt')
OUTPUT_PATH = File.join(ROOT, 'output.txt')
repo = Repositories::InMemoryFundLoadRepository.new
builder = Builders::FundLoadBuilder

begin
  File.foreach(INPUT_PATH, chomp: true) do |line|
    line = line.strip
    next if line.empty?

    attrs = JSON.parse(line)
    load = builder.build(attrs.transform_keys(&:to_sym))
    repo.add(load)
  rescue JSON::ParserError => e
    warn "[skip] invalid JSON: #{e.message}"
  rescue StandardError => e
    warn "[skip] #{e.class}: #{e.message}"
  end
rescue Errno::ENOENT => e
  warn "[error] #{e.message}"
  exit 1
end

File.open(OUTPUT_PATH, 'w') do |f|
  repo.records.each do |r|
    out = { id: r.id.to_s, customer_id: r.customer_id.to_s, accepted: false }
    f.puts(JSON.generate(out))
  end
end

exit 0
