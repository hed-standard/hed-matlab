function errors = demoSidecarServices(host)
%% Shows how to call hed-services to process a BIDS JSON sidecar.
% 
%  Example 1: Validate valid JSON sidecar using a HED version.
%
%  Example 2: Validate invalid JSON sidecar using HED URL.
%
%  Example 3: Convert valid JSON sidecar to long uploading HED schema.
%
%  Example 4: Convert valid JSON sidecar to short using a HED version.
%
%  Example 5: Extract a 4-column spreadsheet from a valid JSON sidecar.
%
%  Example 6: Merge a 4-column spreadsheet with a JSON sidecar.

%% Get the options and data
[servicesUrl, options] = getHostOptions(host);
data = getDemoData();
errors = {};

%% Example 1: Validate valid JSON sidecar using a HED version.
request1 = getRequestTemplate();
request1.service = 'sidecar_validate';
request1.schema_version = '8.2.0';
request1.sidecar_string = data.jsonText;
request1.check_for_warnings = true;
response1 = webwrite(servicesUrl, request1, options);
response1 = jsondecode(response1);
outputReport(response1, 'Ex 1: validate a valid JSON sidecar.');
if ~isempty(response1.error_type) || ...
   ~strcmpi(response1.results.msg_category, 'success')
   errors{end + 1} = 'Ex 1: failed to validate a correct JSON file.';
end

%% Example 2: Validate invalid JSON sidecar using HED URL.
request2 = getRequestTemplate();
request2.service = 'sidecar_validate';
request2.schema_url = data.schemaUrl;
request2.sidecar_string = data.jsonBadText;
request2.check_for_warnings = true;
response2 = webwrite(servicesUrl, request2, options);
response2 = jsondecode(response2);
outputReport(response2, 'Ex 2: validate an invalid JSON sidecar.');
if isempty(response2.error_type) && ...
   ~isempty(response2.results.msg_category) && ...        
   strcmpi(response2.results.msg_category, 'success')
   errors{end + 1} = 'Ex 2: failed to detect an incorrect JSON file.';
end

%% Example 3: Convert valid JSON sidecar to long uploading HED schema.
request3 = getRequestTemplate();
request3.service = 'sidecar_to_long';
request3.schema_string = data.schemaText;
request3.sidecar_string = data.jsonText;
request3.expand_defs = false;
response3 = webwrite(servicesUrl, request3, options);
response3 = jsondecode(response3);
outputReport(response3, 'Ex 3: convert a JSON sidecar to long form.');
if ~isempty(response3.error_type) || ...
   ~strcmpi(response3.results.msg_category, 'success')
   errors{end + 1} = 'Ex 3: failed to convert a valid JSON to long.';
end

%%  Example 4: Convert valid JSON sidecar to short using a HED version.
request4 = getRequestTemplate();
request4.service = 'sidecar_to_short';
request4.schema_version = '8.2.0';
request4.sidecar_string = data.jsonText;
request4.expand_defs = true;
response4 = webwrite(servicesUrl, request4, options);
response4 = jsondecode(response4);
outputReport(response4, 'Ex 4: convert a JSON sidecar to short form.');
if ~isempty(response4.error_type) || ...
   ~strcmpi(response4.results.msg_category, 'success')
   errors{end + 1} = 'Ex 4: failed to convert a valid JSON to short.';
end

%%  Example 5: Extract a 4-column spreadsheet from a JSON sidecar.
request5 = getRequestTemplate();
request5.service = 'sidecar_extract_spreadsheet';
request5.sidecar_string = data.jsonText;
response5 = webwrite(servicesUrl, request5, options);
response5 = jsondecode(response5);
outputReport(response5, 'Ex 5: get 4-col spreadsheet from JSON sidecar.');
if ~isempty(response5.error_type) || ...
   ~strcmpi(response5.results.msg_category, 'success')
   errors{end + 1} = 'Ex 5: failed get 4-col spreadsheet from sidecar.';
end

%%  Example 6: Merge a 4-column spreadsheet with a JSON sidecar.
request6 = getRequestTemplate();
request6.service = 'sidecar_merge_spreadsheet';
request6.sidecar_string = '';
request6.spreadsheet_string = data.spreadsheetTextExtracted;
response6 = webwrite(servicesUrl, request6, options);
response6 = jsondecode(response6);
outputReport(response6, 'Ex 6: merge a 4-col spreadsheet with sidecar.');
if ~isempty(response6.error_type) || ...
  ~strcmpi(response6.results.msg_category, 'success')
   errors{end + 1} = 'Ex 6: failed merge 4-col spreadsheet with sidecar.';
end 
