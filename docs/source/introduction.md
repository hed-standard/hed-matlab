# Getting started

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

- **Requires one-time Python setup** (Python 3.10+, HEDTools package)
- **Provides better performance** than web services
- **Works offline** once configured
- **Provides access to additional features** not available through web services

For Python installation instructions, see the [Python installation guide](user_guide.md#matlab-python-install) in the user guide.

## Quick example

Here's a simple example to get you started with HED validation in MATLAB:

````{admonition} HED validation in MATLAB using web services
---
class: tip
---
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
````

For more examples and detailed usage, see the MATLAB HEDTools [user guide](user_guide.md).

## Related HED resources

- **[HED homepage](https://www.hedtags.org)**: Overview and links for HED
- **[HED schemas](https://www.hedtags.org/hed-schemas)**: Standardized vocabularies in XML/MediaWiki/OWL formats
- **[HED specification](https://www.hedtags.org/hed-specification/)**: Formal specification defining HED annotation rules
- **[HED online tools](https://hedtools.org/hed)**: Web-based interface requiring no programming
- **[HED resources](https://www.hedtags.org/hed-resources)**: Comprehensive tutorials and documentation
- **[Python HEDTools](https://www.hedtags.org/hed-python)**: Python library that powers these MATLAB tools
- **[EEGLAB HEDTools plug-in](https://www.hedtags.org/hed-resources/HedAndEEGLAB.html)**: Integration for EEGLAB users

## Getting help

### Documentation resources

- **[User guide](user_guide.md)**: Step-by-step instructions and examples
- **[API reference](api2.rst)**: Detailed MATLAB function documentation
- **[HED specification](https://hed-specification.readthedocs.io/)**: Formal annotation rules
- **[HED resources](https://www.hedtags.org/hed-resources)**: HED tutorials and guides

### Support

- **Issues**: Report bugs or request features on GitHub [issues](https://github.com/hed-standard/hed-matlab/issues)
- **EEGLAB integration**: See the [EEGLAB HEDTools plug-in](https://www.hedtags.org/hed-resources/HedAndEEGLAB.html) documentation
