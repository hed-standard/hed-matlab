%function factors = getFactors(typeTag, events, sidecar, hedSchema)

    % py.importlib.import_module('hed');
    % data = getDemoData();
    % typeTag = 'Condition-variable';
    % bids = py.hed.tools.BidsDataset(dataPath);
    % issues = bids.validate();
    % issueString = string(py.hed.get_printable_issue_string(issues));

host = 'http://127.0.0.1:5000/';
[servicesUrl, options] = getHostOptions(host);
data = getDemoData();
errors = {};
data.remodel2Text = fileread(...
        [dataPath 'other_data/remove_extra_rmdl.json']);
% %% Example 1: Remodel an events file with no summary or HED.
request1 = struct('service', 'events_remodel', ...
                  'schema_version', '8.2.0', ...
                  'remodel_string', data.remodel1Text, ...
                  'events_string', data.eventsText);

response1 = webwrite(servicesUrl, request1, options);
response1 = jsondecode(response1);
outputReport(response1, 'Example 1 Remodel by removing value and sample columns');
if ~isempty(response1.error_type) || ...
   ~strcmpi(response1.results.msg_category, 'success')
   errors{end + 1} = 'Example 1 failed execute the search.';
end


        % input_data = TabularInput(df, sidecar=sidecar, name=name)
        % df_list = [input_data.dataframe.copy()]
        % var_manager = HedTypeManager(
        %     EventManager(input_data, dispatcher.hed_schema))
        % var_manager.add_type(self.type_tag.lower())
        % 
        % df_factors = var_manager.get_factor_vectors(
        %     self.type_tag, self.type_values, factor_encoding="one-hot")