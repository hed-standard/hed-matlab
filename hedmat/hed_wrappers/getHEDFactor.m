function factorVector = getHEDFactor(query, events, hedSchema, ...
    remove_types, include_context, replace_defs)
% Return a logical vector based on the query
%
% Parameters:
%      query - a string query
%      events - a TabularInput file
%      hedSchema - a hedSchema or hedVersion
%      remove_types - a cell array of types to remove.
%      include_context - boolean true->expand context (usually true).
%      replace_defs - boolean true->replace def with definition (usually true).
%

    modelMod = py.importlib.import_module('hed.models');
    qTuple = modelMod.query_service.get_query_handlers({query});
    qHandler = qTuple{1};
    issueString = strjoin(cell(qTuple{3}));
    if ~isempty(issueString)
        throw (MException('getHEDFactor:InvalidQuery', ...
            'Query errors: %s\n', issueString));
    end

    analMod = py.importlib.import_module('hed.tools.analysis');
    event_man = analMod.event_manager.EventManager(events, hedSchema);
    tag_man = analMod.hed_tag_manager.HedTagManager(event_man, ...
        py.list(remove_types));
    hed_objs = tag_man.get_hed_objs(include_context, replace_defs);
    factorVector = modelMod.query_service.search_strings(hed_objs, ...
        qHandler, qTuple{2});
    disp(factorVector)
   