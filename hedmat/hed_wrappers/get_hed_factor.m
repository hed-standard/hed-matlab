function factor_vector = get_hed_factor(query, hed_obj_list)
% Return a logical vector based on whether the HED query is satisfied.
%
% Parameters:
%     query - a string query
%     hed_obj_list - an opaque python list of HedString objects.
%
% Returns; 
%     factor_vector - a vector of 0's and 1's.

    mmod = py.importlib.import_module('hed.models');
    umod = py.importlib.import_module('hed.tools.analysis.annotation_util');
    qtuple = mmod.query_service.get_query_handlers({query});
    qhandler = qtuple{1};
    qname = qtuple{2};
    issue_string = strjoin(cell(qtuple{3}));
    if ~isempty(issue_string)
        throw (MException('getHEDFactor:InvalidQuery', ...
            'Query errors: %s\n', issue_string));
    end
    factor_vector = mmod.query_service.search_hed_objs(hed_obj_list, ...
        qhandler, qname);
    factor_vector = int32(umod.to_factor(factor_vector));
   