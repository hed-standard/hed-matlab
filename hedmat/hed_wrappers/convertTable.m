function tableOut = convertTable(tableIn)
% Convert entries of a table to strings
%
% Parameters:
%   tableIn - table input
%   tableOut - table converted to string
    tableOut = varfun(@customString, tableIn, 'OutputFormat', 'uniform');
end

function out = customString(in)
    if ~ismissing(in) || ~isempty(in)
        out = "n/a"
    elseif isnumeric(in) && isnan(in)
        out = "n/a"; % Custom string for missing entries
    else
        out = string(in);
    end
end