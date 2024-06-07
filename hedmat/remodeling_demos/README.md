# Using the HED remodeling tools in MATLAB

The HED remodeling tools allow users to run a sequence of transformations
and summaries on tabular files in a BIDS dataset or directory tree.

For an introduction to the HED remodeling tools see:
[File remodeling Quickstart](https://www.hed-resources.org/en/latest/FileRemodelingQuickstart.html#).

Details can be found in
[File remodeling tools](https://www.hed-resources.org/en/latest/FileRemodelingTools.html).

Using these tools requires that MATLAB be set up for calling Python and that the
HED Python tools have been installed.

See {Python HEDTools in MATLAB](https://www.hed-resources.org/en/latest/HedMatlabTools.html#getting-started)
for information about setting up the needed environment.

An alternative is to call the remodeling tools from a web-service. 
See [HED services in MATLAB](https://www.hed-resources.org/en/latest/HedMatlabTools.html#hed-services-in-matlab).
Demos of the web service calls from MATLAB can be found in the web-services directory of this repository.
The services require no installation but work on single files rather than the entire dataset.