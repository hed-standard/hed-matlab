function errors = demoEventRemodelingServices(host)
%% Shows how to call hed-services to remodel an events file.
%
%  Example 1: Remodeling an change events file by removing column
%
%  Example 2: Summarize the column values from an event file.
%
%  Example 3: Summarize the HED type tags from an event file
%
%  Example 4: Factor HED columns

%% Get the options and data
[servicesUrl, options] = getHostOptions(host);
data = getDemoData();
errors = {};

% %% Example 1: Remodel an events file with no summary or HED.
request1 = getRequestTemplate();
request1.service = 'events_remodel';
request1.remodel_string = data.remodelRemoveColumnsText;
request1.events_string = data.eventsText;
response1 = webwrite(servicesUrl, request1, options);
response1 = jsondecode(response1);
outputReport(response1, 'Example 1 Remodel by removing value and sample columns');
if ~isempty(response1.error_type) || ...
   ~strcmpi(response1.results.msg_category, 'success')
   errors{end + 1} = 'Example 1 failed execute the search.';
end

%% Example 2: Remodel an events file with summary and no HED.
request2 = getRequestTemplate();
request2.service = 'events_remodel';
request2.remodel_string = data.remodelSummarizeColumnsText;
request2.events_string = data.eventsText;
response2 = webwrite(servicesUrl, request2, options);
response2 = jsondecode(response2);
outputReport(response2, 'Example 2 Remodel by summarizing columns');
if ~isempty(response2.error_type) || ...
   ~strcmpi(response2.results.msg_category, 'success')
   errors{end + 1} = 'Example 2 failed execute the search.';
end

%% Example 3: Summarize files including HED
request3 = getRequestTemplate();
request3.service = 'events_remodel';
request3.schema_version = '8.2.0';
request3.remodel_string = data.remodelSummarizeColumnsText;
request3.events_string = data.eventsText;
request3.sidecar_string = data.jsonText;
response3 = webwrite(servicesUrl, request3, options);
response3 = jsondecode(response3);
outputReport(response3, 'Example 3 Remodel by summarizing columns');
if ~isempty(response3.error_type) || ...
   ~strcmpi(response3.results.msg_category, 'success')
   errors{end + 1} = 'Example 3 failed to execute summarizeTypes.';
end

%% Example 4: Factor HED types
request4 = getRequestTemplate();
request4.service = 'events_remodel';
request4.schema_version = '8.2.0';
request4.remodel_string = data.remodelFactorTypesText;
request4.events_string = data.eventsText;
request4.sidecar_string = data.jsonText;
response4 = webwrite(servicesUrl, request4, options);
response4 = jsondecode(response4);
outputReport(response4, 'Example 4 Remodel by factoring types');
if ~isempty(response4.error_type) || ...
   ~strcmpi(response4.results.msg_category, 'success')
   errors{end + 1} = 'Example 4 failed to execute factor types.';
end
