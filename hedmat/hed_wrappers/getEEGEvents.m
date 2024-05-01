function eventTable = getEEGEvents(events, srate)
% Returns a MATLAB table suitable to represent BIDS events.
% 
% Parameters:
%    events - the EEGLAB EEG.event struct
%    srate - the EEG sampling rate in Hz
%
% Returns:
%     eventTable - a table representing the events structure
%
% Notes:  If events doesn't have an onset column, it adds it based on
% the latency column. It converts columns other than 
%
   eventTable = struct2table(events);
   columnNames = eventTable.Properties.VariableNames;
   if ~ismember('onset', columnNames)
       latency = eventTable.latency;
       if iscell(latency) || isstring(latency)
           latency = str2double(latency);
       end
       if ~isnumeric(srate)
           srate = double(srate);
       end
       eventTable.onset = (latency - 1)./srate;
   end
   for k=1:length(columnNames)
       thisColumn = columnNames{k};
       columnMask1 = ismissing(eventTable.(thisColumn)) | ...
           isempty(eventTable.(thisColumn));
       if isnumeric(eventTable.(thisColumn))
           % Create mask only if the column is numeric
           columnMask2 = isnan(eventTable.(thisColumn));
       else
           % If not numeric, create a false mask of the same size
           columnMask2 = false(size(eventTable.(thisColumn)));
       end
       eventTable.(thisColumn) = string(eventTable.(thisColumn));
       eventTable.(thisColumn)(columnMask1 | columnMask2) = "n/a";
   end
   

   