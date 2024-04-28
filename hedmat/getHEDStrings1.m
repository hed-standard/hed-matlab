function hedStrings = getHEDStrings(events, hedSchema, ...
    remove_types, include_context, replace_defs)
% Returns an opaque python list of HED string objects
%
% Parameters:
%      events - a TabularInput obj
%      hedSchema - a hedSchema or hedVersion
%      remove_types - a cell array of types to remove.
%      include_context - boolean true->expand context (usually true).
%      replace_defs - boolean true->replace def with definition (usually true).
% Returns

    analMod = py.importlib.import_module('hed.tools.analysis');
    event_man = analMod.event_manager.EventManager(events, hedSchema);
    tag_man = analMod.hed_tag_manager.HedTagManager(event_man, ...
        py.list(remove_types));
    hedStrings = tag_man.get_hed_objs(include_context, replace_defs);
end