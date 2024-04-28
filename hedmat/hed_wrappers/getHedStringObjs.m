function hedObjs = getHedStringObjs(events, hedSchema, remove_types, ...
                                 include_context, replace_defs)
% Return a Python list of HedString objects -- used as input for search.
%
% Parameters:
%      events - a TabularInput obj
%      hedSchema - a hedSchema or hedVersion
%      remove_types - a cell array of types to remove.
%      include_context - boolean true->expand context (usually true).
%      replace_defs - boolean true->replace def with definition (usually true).
%
% Returns:
%    hedObjs (py.list of HedString objects)
%
% Note this is used as the basis for HED queries or for assembled HED.
% To manipulate directly in MATLAB -- convert to a cell array of char
% using string(cell(hedObjs))

    analMod = py.importlib.import_module('hed.tools.analysis');
    event_man = analMod.event_manager.EventManager(events, hedSchema);
    tag_man = analMod.hed_tag_manager.HedTagManager(event_man, ...
        py.list(remove_types));
    hedObjs = tag_man.get_hed_objs(include_context, replace_defs);
   

