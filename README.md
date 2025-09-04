# Fund Load Restrictions Processing Challenge

## Overview
A Ruby CLI that processes fund load requests and enforces velocity limits and special rules. Each input line is JSON, built into a `Models::FundLoad`, normalized (e.g., Monday doubles toward limits), evaluated against business rules (daily/weekly amount, daily count, prime-ID sanctions), stored in-memory, and emits a JSON decision per line to the output file.

## Assumptions & Decisions
- ISO week is Mon–Sun for weekly limits
- Only accepted loads count toward daily/weekly velocity limits
- Monday loads count double toward limits; stored amount remains unchanged
- Prime-ID rule is global per calendar day; prime-ID loads must be ≤ $9,999
- `load_amount` parsing accepts "$1,234.56" and "USD$1,234.56" (letters stripped), commas and `$` allowed
- Time is treated as UTC; builder parses ISO8601 via `Time.iso8601(...).utc`

## Project Layout
- `bin/run.rb`: CLI entrypoint, streaming pipeline, accepts ENV `INPUT_PATH`/`OUTPUT_PATH`
- `lib/models/fund_load.rb`: immutable value object for loads
- `lib/builders/fund_load_builder.rb`: parses/validates input into `FundLoad`
- `lib/normalizers/*`: normalization steps (e.g., Monday doubling for limits)
- `lib/rules/*`: business rules (daily/weekly amount, daily count, prime-id)
- `lib/repositories/*`: repository abstraction and in-memory implementation

## Requirements
- Ruby 3.x
- Install dependencies:
```bash
bundle install
```

## Run
- Defaults:
```bash
./bin/run.rb             # uses input.txt -> output.txt
./bin/run.rb input.txt output.txt
```
- ENV-based:
```bash
INPUT_PATH=spec/fixtures/input_corner_cases.txt \
OUTPUT_PATH=tmp/out.txt \
./bin/run.rb
```
- Behavior:
  - No STDOUT output on success
  - Errors to STDERR and exit 1 on fatal issues

## Tests
```bash
bundle exec rspec
```

## Quality
- Lint: `bundle exec rubocop`
- Overcommit (optional):
  - Pre-commit: `bundle exec rubocop`
  - Pre-push: `bundle exec rspec`
  - Temporarily bypass: `git commit --no-verify` or `OVERCOMMIT_DISABLE=1 git commit -m ...`

## Docs
- Generate API docs:
```bash
bundle exec rdoc --quiet --op doc ./lib ./bin
```
- `doc/` is ignored by git

## How to Reproduce
```bash
./bin/run.rb input.txt output.txt
# or with ENV
INPUT_PATH=input.txt OUTPUT_PATH=output.txt ./bin/run.rb
```
