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
       eventTable.onset = (eventTable.latency - 1)./srate;
   end
   for k=1:length(columnNames)
       thisColumn = columnNames{k};
       if ismember(thisColumn, {'onset', 'duration', 'sample', 'latency'})
           continue;
       end
       % Convert other columns to string and replace missing with `n/a`.
       eventTable.(thisColumn) = string(eventTable.(thisColumn));
       eventTable.(thisColumn)(eventTable.(thisColumn) == "" | ...
           ismissing(eventTable.(thisColumn))) = "n/a";
   end
   

   