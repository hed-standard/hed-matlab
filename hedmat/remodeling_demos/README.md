# Using the HED remodeling tools in MATLAB

The HED remodeling tools allow users to run a sequence of transformations
and summaries on tabular files in a BIDS dataset or directory tree. 

Using these tools requires that MATLAB be set up for calling Python and that the
HED Python tools and [Table-remodeler](https://www.hedtags.org/table-remodeler) have been installed in your MATLAB environment. See the [MATLAB Python installation](https://www.hedtags.org/hed-matlab/user_guide.html#matlab-python-install) guide for more information. 

An alternative is to call the remodeling tools from a web-service. 
See [HED services in MATLAB](https://www.hed-resources.org/en/latest/HedMatlabTools.html#hed-services-in-matlab).
Demos of the web service calls from MATLAB can be found in the web-services directory of this repository.
The services require no installation but work on single files rather than the entire dataset.