function errors = demoEventSearchServices(host)
%% Shows how to call hed-services to search a BIDS events file.
%
%  Example 1: Search an events file for HED using a valid query.
%
%  Example 2: Search an events file for HED and return additional columns.

%% Get the options and data
[servicesUrl, options] = getHostOptions(host);
data = getDemoData();
errors = {};

%% Example 1: Search an events file for HED
request1 = getRequestTemplate();
request1.service = 'events_search';
request1.schema_version = '8.2.0';
request1.events_string = data.eventsText;
request1.sidecar_string = data.jsonText;
request1.queries = {'Intended-effect, Cue'};
request1.expand_defs = true;
response1 = webwrite(servicesUrl, request1, options);
response1 = jsondecode(response1);
outputReport(response1, 'Example 1 Querying an events file');
if ~isempty(response1.error_type) || ...
   ~strcmpi(response1.results.msg_category, 'success')
   errors{end + 1} = 'Example 1 failed execute the search.';
end

%% Example 2: Search an events file for HED
request2 = getRequestTemplate();
request2.service = 'events_search';
request2.schema_version = '8.2.0';
request2.events_string = data.eventsText;
request1.sidecar_string = data.jsonText;
request1.queries = {'Intended-effect, Cue', 'Sensory-event'};
request1.expand_defs = true;
request2 = struct('service', 'events_search', ...
                  'schema_version', '8.2.0', ...
                  'sidecar_string', data.jsonText, ...
                  'events_string', data.eventsText, ...
                  'expand_defs', true, ...
                  'queries', '');
request2.queries = {'Intended-effect, Cue', 'Sensory-event'};
response2 = webwrite(servicesUrl, request2, options);
response2 = jsondecode(response2);
outputReport(response2, 'Example 2 Querying an events file with extra columns');
if ~isempty(response2.error_type) || ...
   ~strcmpi(response2.results.msg_category, 'success')
   errors{end + 1} = 'Example 2 failed execute the search.';
end

