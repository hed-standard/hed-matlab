function issue_string = validate_bids(data_root)
% Validate the HED annotations in a BIDS dataset.
% 
% Parameters:
%    data_root  - Full path to the root directory of a BIDS dataset.
%
% Returns:
%     issue_string - A string with the validation issues suitable for
%                   printing (has newlines).
%
    py.importlib.import_module('hed');
    bids = py.hed.tools.BidsDataset(data_root);
    issues = bids.validate();
    issue_string = string(py.hed.get_printable_issue_string(issues));
