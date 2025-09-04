# Fund Load Restrictions Processing Challenge

## Approach

I used **ChatGPT** to generate development prompts and **Cursor** to scaffold and implement the code.  
Where it was faster, I made manual tweaks myself to improve clarity and efficiency.  

All the cursor prompts are stored in the cursor_prompts folder.

## Known Limitations

1. **Prime ID sanction conflict**  
   - Implemented as a rule rather than a normalizer.  
   - As a result, prime-ID loads above $5,000 are rejected.  
   - A better approach would be to normalize and introduce a boolean flag to skip daily limits.  

2. **Rejected loads not counted**  
   - Only **accepted** loads contribute to daily/weekly velocity limits.  
   - Rejected ones are ignored in my implementation.  

---

## Potential Improvements (If More Time Were Available)

1. **Validation layer**  
   - Add a contract/schema layer to enforce input data validity.  

2. **Configurable rules**  
   - Week start (Monday vs Sunday) and rule thresholds configurable via YAML or database.  

3. **Rule evaluation optimization**  
   - Run cheaper/easier rules first to speed up processing.  

4. **Enhanced data modeling**  
   - Replace `effective_load_amount` with a transformation history array for traceability.  

5. **Testing improvements**  
   - Introduce RSpec factories for cleaner, reusable test data.  

6. **Repository enhancements**  
   - Add iterators in the in-memory repository to mimic ActiveRecord and ease future migration.  

7. **Serialization layer**  
   - Introduce a dedicated serializer for consistent output formatting.  

8. **Output handling refactor**  
   - Extract output logic into its own class for clarity and scalability.  

---

## How to Run

### Default
```bash
./bin/run.rb
```

### Using ENV (preferred for tests/fixtures)
```bash
INPUT_PATH=spec/fixtures/input_corner_cases.txt OUTPUT_PATH=tmp/output_corner_cases.txt ./bin/run.rb
```

---

## Tests

```bash
bundle exec rspec
```

Includes:
- Unit tests for models, repositories, and builder.  
- End-to-end test verifying that `input_corner_cases.txt` produces the expected output.  

---

## Code Quality

- **Linting:** `bundle exec rubocop`  
- **Pre-commit hooks:** Overcommit runs RuboCop before commit and RSpec before push.  