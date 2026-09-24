# hed-matlab

Purpose: MATLAB tools for HED (Hierarchical Event Descriptors) - the `HedTools` interface with a web-service implementation (`HedToolsService`) and a local-Python implementation (`HedToolsPython`), utilities, demos, and the Sphinx documentation site.

Not in scope: the HED Python library itself (hed-python) and the web service it calls (hed-server).

## Commands

Test framework: matlab.unittest (no Python test suite). Never convert the suite to another framework as a side effect of other work.

Run the Python tools from the activated `.venv`, not through `uvx`.

- Install dev env: `uv venv --clear .venv`, activate it, then `uv pip install -e ".[dev,docs]"` and `python docs/patch_matlabdomain.py` (required after every install of `sphinxcontrib-matlabdomain`; it fixes a Sphinx 7+ incompatibility in that package)
- Run tests (MATLAB): `matlab -batch "addpath(genpath('hedmat')), addpath(genpath('tests')), run_tests"` - CI runs the same command in `.github/workflows/ci.yaml`
- Lint / format: `python -m ruff check .` and `python -m ruff format --check .`
- Markdown format: `python -m mdformat --check --wrap no --number docs/ *.md`
- Spelling: `typos`
- Build docs: `python -m sphinx -b html docs docs/_build/html` (the Sphinx source root is `docs/`, not `docs/source/`)

## Layout

- `hedmat/hedtools/` - the `HedTools` interface and its service and Python implementations
- `hedmat/utilities/` - helper functions for common operations
- `hedmat/web_services_demos/`, `hedmat/remodeling_demos/` - usage examples
- `tests/` - MATLAB unit tests (`Test*.m`), run by `tests/run_tests.m`
- `docs/` - Sphinx source (markdown and `.rst`); `docs/_static/` holds images and assets
- `data/` - sample BIDS data and HED schema files for the demos and tests
- `.status/` - working notes. Gitignored; local to each machine.

## Conventions that differ from defaults

- **ASCII only** in prose, code, comments, and filenames: `-` not em or en dashes, `->` not arrows, `...` not an ellipsis character, straight quotes. Exception: genuine data (author names, dataset titles, recorded API responses) keeps whatever characters it actually contains.
- Markdown headers are sentence case: capitalize only the first word, proper nouns, and acronyms (MATLAB, HED, Python).
- MATLAB: camelCase for functions, UPPER_CASE for constants. Document functions with `%%` section headers covering syntax, inputs, outputs, and an example. File names must match the function or class name, so `.m` files keep their mixed case.
- Code blocks in docs use the `matlab` tag for MATLAB and the `hed` tag for HED strings; inline HED tags go in backticks (`Sensory-event`). Show short form and long form where it helps.
- Distinguish the HED specification version (3.x.x) from the schema version (8.x.x), and say which specification version introduces a feature.

## Rules that are easy to get wrong

- `tests/run_tests.m` prints results but never asserts, so `matlab -batch ... run_tests` exits 0 even when tests fail. Read the `Totals:` line; do not trust the exit code.
- `HedToolsPython` needs the `hedtools` Python package installed in the Python that MATLAB uses (`pyenv`), which is not necessarily `.venv`. `HedToolsService` tests need a reachable HED web service.
- Do not modify the HED schema files under `data/schema_data/` - they are reference copies.
- Do not change a MATLAB function signature in `hedmat/` without discussion; downstream users call them directly.

## Related repositories

Referred to by name; none is vendored here.

- `hed-python` - the `hedtools` Python package that `HedToolsPython` calls.
- `hed-server` - the web service that `HedToolsService` calls.
- `hed-schemas` - the published HED schemas.
- `hed-specification` - the HED specification.

## Where the thinking lives

`.status/` is gitignored, so it exists only on the machine that wrote it and never in a fresh clone or worktree.

- `.status/README.md` - the index. Read this first; it lists what is active.
- `.status/decisions.md` - why things are the way they are. Read before proposing structural changes. Append entries; never rewrite one.
- `.status/plans/*.md` - active plans. Check the `Status:` header and the `[ ]` / `[x]` markers before starting work.
- `.status/local-environment.md` - this machine's paths, interpreter, and quirks. Tool-agnostic. Never copy its contents into a committed file.
- IMPORTANT: do not read `.status/archive/` unless a file is named for you. Nothing new is created at the `.status/` root.

## Working agreements

- IMPORTANT: every file written to `.status/` opens with a `For humans:` summary - three or four sentences, at the very top: what the file is and what a person needs to take from it. The same applies to a long answer in a session: lead with the conclusion.
- IMPORTANT: temporary scripts, experiments, and one-off test files go in `.status/scratch/` - **never the repository root**. Delete them when the experiment ends; anything in `scratch/` may be deleted unread.
- IMPORTANT: never delete or rewrite a file under `.status/` without asking first. Appending is fine.
- For a change spanning more than three files, write a plan to `.status/plans/` and stop for review before editing.
- When you are guessing about an external API or data format, say so explicitly rather than assuming.
- Show evidence, not assertions: the command you ran and its actual output.
- Do not commit, push, or create branches unless asked.
