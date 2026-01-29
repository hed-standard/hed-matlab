```{index} development
```

```{index} contributing
```

```{index} documentation; building
```

# Development guide

This guide provides instructions for contributors who want to develop MATLAB HEDTools code or build the documentation locally.

## Installation

### Prerequisites

To build the documentation, you need:

- Python 3.10 or later
- Git (to clone the repository)

### Setting up the development environment

1. **Clone the repository**:

   ```shell
   git clone https://github.com/hed-standard/hed-matlab.git
   cd hed-matlab
   ```

2. **Create and activate a virtual environment** (recommended):

   **On Windows (PowerShell)**:

   ```powershell
   python -m venv .venv
   .venv\Scripts\Activate.ps1
   ```

   **On Linux/macOS**:

   ```bash
   python -m venv .venv
   source .venv/bin/activate
   ```

3. **Install development dependencies**:

   The development and documentation dependencies are defined in `pyproject.toml`. Install them using:

   ```shell
   pip install -e .[dev,docs]
   ```

   This installs all required packages including:

   **Documentation tools:**

   - Sphinx (documentation generator)
   - Furo theme
   - MyST parser (for Markdown support)
   - sphinxcontrib-matlabdomain (for MATLAB code documentation)
   - sphinx-copybutton, sphinx-design, and other extensions

   **Development tools:**

   - ruff (linter and formatter)
   - codespell (spell checker)
   - black (code formatter)
   - mdformat (Markdown formatter)

### Building the documentation

From the repository root, run:

```shell
sphinx-build -b html docs docs/_build/html
```

The generated HTML documentation will be in `docs/_build/html/`. Open `docs/_build/html/index.html` in your browser to view it.

**To rebuild from scratch** (clean build):

```shell
sphinx-build -b html docs docs/_build/html -E
```

The `-E` flag forces a full rebuild of all files, ignoring the cache.

### Serving documentation locally

#### Using the provided batch file (Windows)

From the repository root:

```shell
serve-sphinx.bat
```

This will start a local web server and open the documentation in your browser.

#### Using Python's built-in HTTP server

From the repository root:

```shell
cd docs/_build/html
python -m http.server 8000
```

Then open your browser to [http://localhost:8000](http://localhost:8000)

### Documentation structure

The documentation source files are organized as follows:

| File/Directory        | Description                                                        |
| --------------------- | ------------------------------------------------------------------ |
| `docs/overview.md`    | Overview and installation instructions (main landing page content) |
| `docs/user_guide.md`  | Detailed user guide with examples                                  |
| `docs/development.md` | This development guide                                             |
| `docs/api2.rst`       | API reference (auto-generated from MATLAB code)                    |
| `docs/conf.py`        | Sphinx configuration file                                          |
| `docs/_static/`       | Static assets (images, CSS, etc.)                                  |
| `docs/_templates/`    | Custom Sphinx templates                                            |

### Making changes to documentation

1. **Edit Markdown files**: Most documentation is written in Markdown (`.md` files) using the MyST parser.

2. **Rebuild documentation**: After making changes, rebuild the docs to see your changes:

   ```shell
   sphinx-build -b html docs docs/_build/html
   ```

3. **Check for errors**: Review the build output for any warnings or errors.

4. **Preview changes**: Open the generated HTML in your browser to verify your changes.

### Documentation style guidelines

- Use clear, descriptive headings following the hierarchy: `#` for titles, `##` for sections, `###` for subsections
- Include code examples with proper language tags (```` ```matlab ```` for MATLAB code)
- Use MyST directives for admonitions: ```` ```{admonition} ```` blocks
- Link to files using workspace-relative paths: `[text](path/file.md)`
- Add index entries for important terms using ```` ```{index} term ```` blocks
- Follow the existing style in current documentation files

## MATLAB code development

### Running tests

The MATLAB unit tests are located in the `tests/` directory. To run all tests:

1. **Open MATLAB**

2. **Add hedmat to your path**:

   ```matlab
   addpath(genpath('hedmat'));
   addpath(genpath('tests'));
   ```

3. **Run the test suite**:

   ```matlab
   run_tests
   ```

This will execute all test files matching the pattern `Test*.m` in the `tests/` directory.

### Testing individual components

- **HED tools tests**: `tests/test_hed_tools/`
- **Utilities tests**: `tests/test_utilities/`

To run tests for a specific component, navigate to the test directory and run the individual test file.

### Code style guidelines

- Use clear, descriptive function and variable names
- Include comprehensive doc comments using `%%` section markers
- Follow MATLAB naming conventions: camelCase for functions, UPPER_CASE for constants
- Include examples in function documentation
- Test your code with the unit test framework before submitting

## Contributing workflow

### Reporting issues

If you find a bug or have a feature request:

1. Check the [GitHub issues](https://github.com/hed-standard/hed-matlab/issues) to see if it's already reported
2. If not, create a new issue with:
   - A clear, descriptive title
   - Detailed description of the problem or feature
   - Steps to reproduce (for bugs)
   - Expected vs. actual behavior
   - MATLAB version and operating system

### Submitting changes

1. **Fork the repository** on GitHub

2. **Create a feature branch**:

   ```shell
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**:

   - Write clear, focused commits
   - Follow the code style guidelines
   - Add or update tests as needed
   - Update documentation if needed

4. **Test your changes**:

   - Run the MATLAB test suite
   - Build and review the documentation

5. **Commit your changes**:

   ```shell
   git add .
   git commit -m "Brief description of your changes"
   ```

6. **Push to your fork**:

   ```shell
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request** on GitHub with:

   - Clear description of the changes
   - Reference to related issues (if any)
   - Any breaking changes or migration notes

### Code review process

- All contributions require review before merging
- Be responsive to feedback and questions
- Update your PR based on review comments
- Maintain a clean commit history

## Additional resources

- **[HED specification](https://hed-specification.readthedocs.io/)**: Formal HED annotation rules
- **[HED resources](https://www.hedtags.org/hed-resources)**: Comprehensive tutorials and documentation
- **[Python HEDTools](https://www.hedtags.org/hed-python)**: The Python library that powers MATLAB HEDTools
- **[Sphinx documentation](https://www.sphinx-doc.org/)**: Sphinx documentation generator
- **[MyST parser](https://myst-parser.readthedocs.io/)**: Markdown parser for Sphinx

## Getting help

If you need help with development:

1. Check this guide and the documentation
2. Review existing issues and pull requests
3. Ask questions by opening a GitHub issue with the "question" label
4. For HED-specific questions, see the [HED resources](https://www.hedtags.org/hed-resources)
