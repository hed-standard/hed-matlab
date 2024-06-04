function errors = demoSpreadsheetServices(host)
%% Shows how to call hed-services to process a spreadsheet of event tags.
% 
%  Example 1: Validate valid spreadsheet file using schema version.
%
%  Example 2: Validate invalid spreadsheet file using HED URL.
%
%  Example 3: Convert valid spreadsheet file to long uploading HED schema.
%
%  Example 4: Convert valid spreadsheet file to short using HED version.
%
%% Get the options and data
[servicesUrl, options] = getHostOptions(host);
data = getDemoData();
errors = {};

%% Example 1: Validate valid spreadsheet file using schema version.
request1 = getRequestTemplate();
request1.service = 'spreadsheet_validate';
request1.schema_version = '8.2.0';
request1.spreadsheet_string = data.spreadsheetText;
request1.sidecar_string = data.jsonText;
request1.check_for_warnings = true;
request1.tag_columns = {4};
response1 = webwrite(servicesUrl, request1, options);
response1 = jsondecode(response1);
outputReport(response1, 'Ex 1: validate a valid spreadsheet');

if ~isempty(response1.error_type) || ...
   ~strcmpi(response1.results.msg_category, 'success')
   errors{end + 1} = 'Ex 1: failed to validate correct spreadsheet file.';
end

%% Example 2: Validate invalid spreadsheet file using HED URL.
request2.service = 'spreadsheet_validate';
request2.schema_version = '8.2.0';
request2.spreadsheet_string = data.spreadsheetTextInvalid;
request2.check_for_warnings = true;
request2.tag_columns = {'HED tags'};
response2 = webwrite(servicesUrl, request2, options);
response2 = jsondecode(response2);
outputReport(response2, 'Ex 2: validate an invalid spreadsheet');
if isempty(response2.error_type) && ...
   ~isempty(response2.results.msg_category) && ...     
   strcmpi(response2.results.msg_category, 'success')
   errors{end + 1} = 'Ex 2: failed to detect invalid spreadsheet file.';
end

%% Example 3: Convert valid spreadsheet file to long uploading HED schema.
request3.service = 'spreadsheet_to_long';
request3.schema_string = data.schemaText;
request3.spreadsheet_string = data.spreadsheetText;
request3.expand_defs = true;
request3.tag_columns = {'HED tags'};
response3 = webwrite(servicesUrl, request3, options);
response3 = jsondecode(response3);
outputReport(response3, 'Ex 3: Convert a spreadsheet to long form');
if ~isempty(response3.error_type) || ...
   ~strcmpi(response3.results.msg_category, 'success')
   errors{end + 1} = 'Ex 3: Failed to convert a spreadsheet to long.';
end

%% Example 4: Convert valid spreadsheet file to short using uploaded HED.
request4.service = 'spreadsheet_to_short';
request4.schema_string = data.schemaText;
request4.spreadsheet_string = data.spreadsheetText;
request4.expand_defs = true;
request4.tag_columns = {4};
response4 = webwrite(servicesUrl, request4, options);
response4 = jsondecode(response4);
outputReport(response4, 'Ex 4: Convert a spreadsheet to short form.');
if ~isempty(response4.error_type) || ...
   ~strcmpi(response4.results.msg_category, 'success')
   errors{end + 1} = 'Ex 4: Failed to convert spreadsheet to short.';
end

