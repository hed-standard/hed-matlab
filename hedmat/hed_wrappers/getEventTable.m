function eventTable = getEventTable(eventsFile, numericCols, typeCol, sRate)
% Read the table of events from the events file
%
% Parameters:
%     eventsFile - the path of a BIDS tabular events file.
%     numericColumns - list of columns that are numeric
%     typeCol - column that is to be used as the type.
%     sampleRate - sample rate in Hz.
% 
% Returns:
%     table with the events as read from a BIDS tabular file.
% 
  
   optsDect = detectImportOptions(eventsFile, 'FileType', 'delimitedtext');
   % Set the types and fill values of the columns as specified.
   columnNames = optsDect.VariableNames;
   columnTypes = cell(size(columnNames));
   for m = 1:length(columnNames)
       if ismember(columnNames{m}, numericCols)
           columnTypes{m} = double;
       else
           columnTypes{m} = 'char';
       end
   end
   optsDect = setvartype(optsDect, columnTypes);
   optsDect = setvaropts(optsDect, ...
       columnNames(~strcmpi(columnTypes, 'char')), 'FillValue', NaN);
   optsDect = setvaropts(optsDect, ...
       columnNames(strcmpi(columnTypes, 'char')), 'FillValue', 'n/a');
   
   % Read in the event table
   eventTable = readtable(eventsFile, optsDect);
   
   % Rename the columns that are requested.
   variableNames = eventTable.Properties.VariableNames;
   if ~ismember('type', columnNames) && ismember(typecol, columnNames)
       eventTable.type = string(eventTable.(typecol));
       columnNames = [{'type'}, columnNames];
       eventTable = eventTable(:, columnNames);
   else
       throw (MException('getEventTable:BadTypeColumn', ...
              'Column %s can not be copied as type column', typecol))
   end
   if ~ismember('latency', columnNames) && ismember('onset', columnNames)
       eventTable.latency = round(eventTable.onset/srate) + 1;
       eventTable =  eventTable(:, [{'latency'}, columnNames]);
   end
   for m = 1:length(variableNames)
       if isKey(renameMap, variableNames{m})
           variableNames{m} = renameMap(variableNames{m});
       end
   end
   %eventTable.Properties.VariableNames = variableNames;
   if ~ismember('urevent', columnNames)
       eventTable.urevent = (1:height(eventTable))';
   end
 