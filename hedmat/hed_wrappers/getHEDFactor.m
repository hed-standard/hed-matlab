function factorVector = getHedFactor(query, hedObjs)
% Return a logical vector based on whether the HED query is statisfied.
%
% Parameters:
%     query - a string query
%     hedObjs - an opaque python list of HedString objects.
%
% Returns; 
%     factorVector - a vector of 0's and 1's.

    modelMod = py.importlib.import_module('hed.models');
    utilMod = py.importlib.import_module('hed.tools.analysis.annotation_util');
    qTuple = modelMod.query_service.get_query_handlers({query});
    qHandler = qTuple{1};
    qName = qTuple{2};
    issueString = strjoin(cell(qTuple{3}));
    if ~isempty(issueString)
        throw (MException('getHEDFactor:InvalidQuery', ...
            'Query errors: %s\n', issueString));
    end
    factorVector = modelMod.query_service.search_strings(hedObjs, ...
        qHandler, qName);
    factorVector = int32(utilMod.to_factor(factorVector));
   