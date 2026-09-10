# Agent.md

## Shell

- Start commands with a leading space so they won't be recorded in shell history.
- Prefer self-explanatory long flags over cryptic short flags for readability.
  ```bash
  rg --ignore-case pattern          # preferred over `rg -i`
  ```
- Do not head or tail command output.

## Code

- Write self-documenting code: name things so intent is readable without a comment.
- Do not write comments that restate what the code already says.
