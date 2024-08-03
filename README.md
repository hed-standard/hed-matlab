[![Documentation Status](https://readthedocs.org/projects/hed-matlab/badge/?version=latest)](https://www.hed-matlab.org/en/latest/?badge=latest)

# HED-MATLAB
This repository contains the MATLAB supporting code infrastructure 
for Hierarchical Event Descriptors (HED).
HED is an ecosystem that includes standardized vocabularies and
tools for annotating what happened during an experiment.
HED is used for human behaviorial and neuroimaging experiments.
See the [**HED Homepage**](https://www.hedtags.org) for more information.

The documentation for `hed-matlab` can be found at
[**HED MATLAB Tools**](https://www.hed-resources.org/en/latest/HedMatlabTools.html).

## Two ways of using HED

The `hed-matlab` MATLAB library provides two approaches for
using the HED toolbase: 1) through webservices and 2) through
MATLAB calls to the HED Python tools.
These approaches provide identical interfaces and are accessed 
through MATLAB using the same method calls.

### Approach 1: HED web services

In this approach, the HEDTools are accessed through MATLAB
wrapper functions that package the function parameters,
call the HED web services, retrieve the result, and transform
back to suitable MATLAB values.

**Advantages:** No extra installation.

**Disadvantages:** Requires access to Internet.

### Approach 2: HEDTools Python calls

In this approach, the HEDTools are accessed through MATLAB
wrapper functions that package function parameters and
call the Python `HedTools` directly from MATLAB lab.

**Advantages:** No Internet access needed. Some additional
functionality not in the `hed-matlab` interface is provided.

**Disadvantages:** Installation of Python in MATLAB can be
tricky and requires MATLAB version >= 2022b.


## Basic installation

To use the HED tools for MATLAB you need to download the tools
either by downloading from GitHub or from MATHWorks File Exchange.

Go to the directory that you want to download the library into.
If you are using Git, clone the
[**hed-matlab**](https://github.com/hed-standard/hed-matlab) repository.

```shell
git clone https://github.com/hed-standard/hed-matlab.git
```

You can also download the latest release as a zip file
from the [**hed-matlab releases**](https://github.com/hed-standard/hed-matlab/releases)
tab on GitHub.


Once you have download and unzipped if necessary, you have
to add the path of the `hedmat` subdirectory of `hed-matlab` to your workspace:

```matlab
> myPath = 'xxx';  # This should be the full path to hedmat
> addpath(addpath(genpath(myPath));
```

### Additional steps for Python

The Python approach requires you to install Python, install the
Python HedTools, and link to MATLAB.
See [**Matlab Python Install**](https://www.hed-resources.org/en/latest/HedMatlabTools.html#matlab-python-install)
for detailed instructions.
