# Introduction MATLAB HEDTools

## What is HED?

HED (Hierarchical Event Descriptors) is a framework for systematically describing events and experimental metadata in machine-actionable form. HED provides:

- **Controlled vocabulary** for annotating experimental data and events
- **Standardized infrastructure** enabling automated analysis and interpretation
- **Integration** with major neuroimaging standards (BIDS and NWB)

For more information, visit the [HED project homepage](https://www.hedtags.org).

## What are MATLAB HEDTools?

The **MATLAB HEDTools** package provides MATLAB wrappers for working with HED annotations in MATLAB environments. The tools provide:

- **MATLAB wrapper functions** for HED validation and services
- **Web service demonstrations** and client examples
- **Event data remodeling** and processing utilities
- **Integration examples** with EEGLAB and other MATLAB-based tools
- **Comprehensive API documentation** for MATLAB functions

The MATLAB HEDTools allow validation, summary, search, factorization, data epoching and other HED processing in MATLAB by providing MATLAB wrappers for the Python HEDTools. These MATLAB wrappers allow MATLAB users to use HED without learning Python.

### Related tools and resources

- **[HED homepage](https://www.hedtags.org)**: Overview and links for HED
- **[HED Schemas](https://github.com/hed-standard/hed-schemas)**: Standardized vocabularies in XML/MediaWiki/OWL formats
- **[HED Specification](https://www.hedtags.org/hed-specification/)**: Formal specification defining HED annotation rules
- **[HED Online Tools](https://hedtools.org/hed)**: Web-based interface requiring no programming
- **[HED Examples](https://github.com/hed-standard/hed-examples)**: Example datasets annotated with HED
- **[HED Resources](https://www.hedtags.org/hed-resources)**: Comprehensive tutorials and documentation
- **[HED Python Tools](https://www.hedtags.org/hed-python)**: Python library that powers these MATLAB tools

## Installation

### Downloading MATLAB HEDTools

MATLAB HEDTools can be downloaded from the [**hed-matlab**](https://github.com/hed-standard/hed-matlab) GitHub repository.

**Add the `hedmat` directory and all of its subdirectories to your MATLAB path.**

The following table describes the directories of this repository:

| Directory                   | Description                                                           |
| --------------------------- | --------------------------------------------------------------------- |
| `data`                      | Data used for the demos and tests.                                    |
| `docs`                      | Source code for the documentation.                                    |
| `hedmat/hedtools`           | MATLAB interface for the HED tools.                                   |
| `hedmat/remodeling_demos`   | Demos of calling the table remodeler.                                 |
| `hedmat/utilities`          | General purpose utilities.                                            |
| `hedmat/web_services_demos` | Demos of directly using the HED web services (without hedtools).      |
| `tests`                     | Unit tests for MATLAB. (Execute `run_tests.m` to run all unit tests.) |

### Using web services (no installation required)

The simplest way to use MATLAB HEDTools is through web services. This approach:

- **Requires no installation** beyond downloading the MATLAB HEDTools package
- **Requires Internet access** to connect to HED web services
- Works immediately without any Python setup

See the [User Guide](user_guide.md) for examples of using web services.

### Using direct Python calls (optional)

For more efficient operation and additional functionality, you can configure MATLAB to call the Python HEDTools directly. This approach:

- **Requires one-time Python setup** (Python 3.8+, HEDTools package)
- **Provides better performance** than web services
- **Works offline** once configured
- **Provides access to additional features** not available through web services

For Python installation instructions, see the [Python Installation Guide](user_guide.md#matlab-python-install) in the User Guide.

## Getting help

### Documentation resources

- **[User Guide](user_guide.md)**: Step-by-step instructions and examples
- **[API reference](api2.rst)**: Detailed MATLAB function documentation
- **[HED specification](https://hed-specification.readthedocs.io/)**: Formal annotation rules
- **[HED resources](https://www.hedtags.org/hed-resources)**: HED tutorials and guides

### Support

- **Issues**: Report bugs or request features on [GitHub Issues](https://github.com/hed-standard/hed-matlab/issues)
- **Questions**: Ask on the [HED forum](https://github.com/hed-standard/hed-specification/discussions)
- **EEGLAB integration**: See the [EEGLAB HEDTools plug-in](https://www.hedtags.org/hed-resources/HedAndEEGLAB.html) documentation

## Quick example

Here's a simple example to get you started with HED validation in MATLAB:

```matlab
% Get HED tools using web services
hed = getHedTools('8.4.0', 'https://hedtools.org/hed');

% Validate a string containing HED tags
issues = hed.validateTags('Sensory-event,Red,(Image,Face)');

if isempty(issues)
    disp('✓ HED string is valid!');
else
    disp(issues);
end
```

For more examples and detailed usage, see the MATLAB HEDTools [user guide](user_guide.md).
