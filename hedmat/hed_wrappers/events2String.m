function eventString = events2String(events)
% Returns string representing a rectified EEG.event structure
% 
% Parameters:
%    events - the EEGLAB EEG.event struct or similar
%    srate - the EEG sampling rate in Hz (needed if no onset column)
%
% Returns:
%     eventString - a string representation suitable to write to .tsv
%
% Note 1: The conversion converts NaN to n/a.
%
% Note 2:  This assumes that the events structure has been rectified by
% adding onset and duration fields as required by BIDS.
%
    events = events(:);
    fields = fieldnames(events);
    cellEvents = struct2cell(events(:))';
    [rows, ~] = size(cellEvents);
    cellColumn = cell(rows + 1, 1);
    cellColumn{1} = getRowString(fields(:)');
    for k = 1:rows
        cellColumn{k+1} = getRowString(cellEvents(k, :));
    end
    eventString = strjoin(string(cellColumn), '\n');

end

function rowString = getRowString(cells)
% Convert a row of cells to tab-separated string.
    cellsAsStrings = cell(size(cells));
    for k = 1:length(cells)
        cellsAsStrings{k} = getString(cells{k});
    end
    rowString = strjoin(string(cellsAsStrings), '\t');
end

function elString = getString(element)
% Convert a cell element to string with NaN replaced by n/a.
    if any(ismissing(element)) || any(isempty(element))
        elString = "n/a";
    elseif any(isnumeric(element) & isnan(element))
        elString = "n/a";
    else
        elString = string(element);
    end  
end   

   