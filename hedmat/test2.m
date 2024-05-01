

events1(3) = struct('onset', 3.2, 'duration', NaN, 'latency', 6234, ...
                 'response', 2.1, 'type', 'apple');
events1(2) = struct('onset', 2.2, 'duration', NaN, 'latency', 5234, ...
                 'response', NaN, 'type', 'pear');
events1(1) = struct('onset', 1.1, 'duration', NaN,  'latency', 4234, ...
                 'response', 1.5, 'type', 'banana');


cell2 = struct2cell(events1(:))';
[rows, cols] = size(cell2);
cellColumn = cell(rows + 1, 1);
fields = fieldnames(events1);
cellColumn{1} = getRowString(fields(:)');
for k = 1:rows
    cellColumn{k+1} = getRowString(cell2(k, :));
end

% events2 = events1(:);
% cell2 = struct2cell(events2)';
% [rows, cols] = size(cell2);
% cellColumn = cell(rows + 1, 1);
% fields = fieldnames(events2);
% cellColumn{1} = getRowString(fields(:)');
% for k = 1:rows
%     cellColumn{k+1} = getRowString(cell2(k, :));
% end


result = strjoin(string(cellColumn), '\n');

fid = fopen('g:\temp1.tsv', 'w');
fprintf(fid, '%s\n', result);
fclose(fid);
