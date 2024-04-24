function eventsObj = getEvents(events, sidecar)
% Returns a HEDTools TabularInput object representing events.
% 
% Parameters:
%    events - string, table or Pandas DataFrame
%    sidecar - Sidecar object, string, or struct or py.None
%
% Returns:
%     TabularInput - HEDTools object representing an events file.
%
    hedModule = py.importlib.import_module('hed'); 
    utilModule = py.importlib.import_module('hed.tools.analysis.annotation_util'); 
    if py.isinstance(events, hedModule.TabularInput)
        eventsObj = events;
        return;
    end
    if isempty(sidecar) || (isa(sidecar, 'py.NoneType') && sidecar == py.None)
        sidecarObj = py.None;
    else
        sidecarObj = getSidecar(sidecar);
    end
    if ischar(events)
        eventsObj = utilModule.str_to_tabular(events, sidecarObj);
    else
        throw(MException('getEvents:Invalid input'))
    end
end
