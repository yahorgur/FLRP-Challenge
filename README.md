# Fund Load Restrictions Processing Challenge

## Project Description
This project is a Ruby implementation of the Fund Load Restrictions Processing Challenge. It will parse incoming load requests and enforce velocity limits such as:
- Daily amount limit
- Weekly amount limit
- Per-customer load count limit

Optionally, the solution may apply additional “sanctions” or business rules (e.g., handling customers with prime IDs differently, or special handling for requests on Mondays).

## Setup
1. Clone the repository and enter the project directory:
```bash
git clone <your-repo-url>
cd Fund-Load-Restrictions-Processing-Challenge
```
2. Install dependencies:
```bash
bundle install
```

## Running the Script
- Entrypoint is `bin/run.rb`.
- Make it executable:
```bash
chmod +x bin/run.rb
```
- Example run (reads `input.txt` and writes results to `output.txt`):
```bash
./bin/run.rb input.txt > output.txt
```

## Running Tests
Run the RSpec test suite:
```bash
bundle exec rspec
```

## Code Quality
RuboCop is used for style checks and Overcommit manages Git hooks:
- Pre-commit: `bundle exec rubocop`
- Pre-push: `bundle exec rspec`

## Architecture
- Model: `Models::FundLoad` includes `effective_amount` which defaults to `amount`.
- Normalization: Stateless, idempotent pipeline (e.g., MondayAmountNormalizer doubles `effective_amount` on Mondays). UTC assumed if timezone missing.
- Rules: Evaluate a candidate against previously accepted loads via the accepted repository only (attempts are not considered). ISO weeks are used for weekly rules.

## Prompt Tracking
All prompts are tracked in `cursor_prompts/` as separate `.md` files with timestamped filenames.
