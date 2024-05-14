function hed_string_objs = get_string_objs(events, schema, remove_types, ...
                                 include_context, replace_defs)
% Return a Python list of HedString objects -- used as input for search.
%
% Parameters:
%      events - a TabularInput obj
%      schema - a hedSchema or hedVersion
%      remove_types - a cell array of types to remove.
%      include_context - boolean true->expand context (usually true).
%      replace_defs - boolean true->replace def with definition (usually true).
%
% Returns:
%    hed_string_objs (py.list of HedString objects)
%
% Note this is used as the basis for HED queries or for assembled HED.
% To manipulate directly in MATLAB -- convert to a cell array of char
% using string(cell(hedObjs))

    hmod = py.importlib.import_module('hed');
    event_manager = hmod.EventManager(events, schema);
    tag_manager = hmod.HedTagManager(event_manager, ...
        py.list(remove_types));
    hed_string_objs = ...
        tag_manager.get_hed_objs(include_context, replace_defs);
   

