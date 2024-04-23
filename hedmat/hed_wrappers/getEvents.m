function eventsObj = getEvents(events, sidecar)
% Returns a HEDTools TabularInput object representing events.
% 
% Parameters:
%    events - string, table or Pandas DataFrame
%    sidecar - Sidecar object, string, or struct
%
% Returns:
%     TabularInput - HEDTools object representing an events file.
%
    hedModule = py.importlib.import_module('hed'); 
    utilModule = py.importlib.import_module('hed.tools.analysis.annotation_util'); 
    sidecarObj = getSidecar(sidecar);
    if py.isinstance(events, hedModule.TabularInput)
        eventsObj = events;
    elseif ischar(events)
        eventsObj = utilModule.str_to_tabular(events, sidecarObj);
    else
        eventsObj = py.None;
    end
end
