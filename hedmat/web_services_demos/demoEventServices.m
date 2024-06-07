function errors = demoEventServices(host)

%% Shows how to call hed-services to process a BIDS events file.
% 
%  Example 1: Validate valid events file using HED version.
%
%  Example 2: Validate invalid events file using a HED URL.
%
%  Example 3: Assemble valid event HED strings uploading HED schema.
%
%  Example 4: Assemble valid event HED strings (def expand) using HED version.
%
%  Example 5: Generate a JSON sidecar template from an events file.


%% Get the options and data
[servicesUrl, options] = getHostOptions(host);
data = getDemoData();
errors = {};

%% Example 1: Validate valid events file using HED version.
request1 = getRequestTemplate();
request1.service = 'events_validate';
request1.schema_version = '8.2.0';
request1.events_string = data.eventsText;
request1.sidecar_string = data.jsonText;
request1.check_for_warnings = false;
response1 = webwrite(servicesUrl, request1, options);
response1 = jsondecode(response1);
outputReport(response1, 'Ex 1: validating a valid event file.');
if ~isempty(response1.error_type) || ...
   ~strcmpi(response1.results.msg_category, 'success')
   errors{end + 1} = 'Ex 1: failed to validate a correct event file.';
end

%% Example 2: Validate invalid events file using a HED URL.
request2 = getRequestTemplate();
request2.service = 'events_validate';
request2.schema_version = '8.2.0';
request2.events_string = data.eventsText;
request2.sidecar_string = data.jsonBadText;
request2.check_for_warnings = true;
response2 = webwrite(servicesUrl, request2, options);
response2 = jsondecode(response2);
outputReport(response2, 'Ex 2: validating events with invalid JSON.');
if isempty(response2.error_type) && ...
    ~isempty(response2.results.msg_category) && ...        
    strcmpi(response2.results.msg_category, 'success')
   errors{end + 1} = 'Ex 2: failed detect event file validation errors.';
end

%% Example 3: Assemble valid events file uploading a HED schema
request3 = getRequestTemplate();
request3.service = 'events_assemble';
request3.schema_version = '8.2.0';
request3.events_string = data.eventsText;
request3.sidecar_string = data.jsonText;
request3.expand_defs = false;
response3 = webwrite(servicesUrl, request3, options);
response3 = jsondecode(response3);
outputReport(response3, 'Ex 3: output for assembling valid events file');
if ~isempty(response3.error_type) || ...
   ~strcmpi(response3.results.msg_category, 'success')
   errors{end + 1} = 'Ex 3: failed assemble a correct events file.';
end

%%  Example 4: Assemble valid event HED strings(expand defs on).
request4 = getRequestTemplate();
request4.service = 'events_assemble';
request4.schema_version = '8.2.0';
request4.events_string = data.eventsText;
request4.sidecar_string = data.jsonText;
request4.expand_defs = true;
response4 = webwrite(servicesUrl, request4, options);
response4 = jsondecode(response4);
outputReport(response4,'Ex 4: assembling HED annotations for events.');
if ~isempty(response4.error_type) || ...
   ~strcmpi(response4.results.msg_category, 'success')
   errors{end + 1} = 'Ex 4: failed assemble events file with expand defs.';
end

%%  Example 5: Generate a sidecar template from an events file.
request5 = getRequestTemplate();
request5.service = 'events_generate_sidecar';
request5.events_string = data.eventsText;
request5.columns_skip = {'onset', 'duration', 'sample'};
request5.columns_value = {'trial', 'rep_lag', 'stim_file'};
response5 = webwrite(servicesUrl, request5, options);
response5 = jsondecode(response5);
outputReport(response5, 'Ex 5: generate a sidecar from an event file.');
if ~isempty(response5.error_type) || ...
   ~strcmpi(response5.results.msg_category, 'success')
   errors{end + 1} = 'Ex 5: failed to generate a sidecar correctly.';
end
