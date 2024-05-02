function event_string = events2string(events)
% Returns string representing a rectified EEG.event structure
% 
% Parameters:
%    events - the EEGLAB EEG.event struct or similar
%    srate - the EEG sampling rate in Hz (needed if no onset column)
%
% Returns:
%     event_string - a string representation suitable to write to .tsv
%
% Note 1: The conversion converts NaN to n/a.
%
% Note 2:  This assumes that the events structure has been rectified by
% adding onset and duration fields as required by BIDS.
%
    events = events(:);
    fields = fieldnames(events);
    cell_events = struct2cell(events(:))';
    [rows, ~] = size(cell_events);
    cell_column = cell(rows + 1, 1);
    cell_column{1} = get_row_string(fields(:)');
    for k = 1:rows
        cell_column{k+1} = get_row_string(cell_events(k, :));
    end
    event_string = strjoin(string(cell_column), '\n');

end

function row_string = get_row_string(cells)
% Convert a row of cells to tab-separated string.
    cell_strings = cell(size(cells));
    for k = 1:length(cells)
        cell_strings{k} = get_element_string(cells{k});
    end
    row_string = strjoin(string(cell_strings), '\t');
end

function element_string = get_element_string(element)
% Convert a cell element to string with NaN replaced by n/a.
    if any(ismissing(element)) || any(isempty(element))
        element_string = "n/a";
    elseif any(isnumeric(element) & isnan(element))
        element_string = "n/a";
    else
        element_string = string(element);
    end  
end   

   