

events1(3) = struct('onset', 3.2, 'latency', 6234, ...
                 'response', 2.1, 'type', 'apple');
events1(2) = struct('onset', 2.2, 'latency', 5234, ...
                 'response', NaN, 'type', 'pear');
events1(1) = struct('onset', 1.1, 'latency', 4234, ...
                 'response', 1.5, 'type', 'banana');
table1 = getEEGEvents(events1, '500');

tName = [tempname, '.tsv']
writetable(table1, tName, "FileType", "text", "Delimiter", "\t")

events2 = events1(:);
fieldnames = fieldnames(events2);
for k = 1:length(events2)
   theCells = cell(1, length(fieldnames));
end


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
   