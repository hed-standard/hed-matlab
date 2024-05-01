function tabObj = getTabularInput(events, sidecar)
% Returns a TabularInput object representing events or other columnar item.
% 
% Parameters:
%    events - string, table, struct or Pandas DataFrame for tabular data.
%    sidecar - Sidecar object, string, or struct or py.None
%
% Returns:
%     tabObj - HEDTools TabularInputobject representing tabular data.
%
    hedModule = py.importlib.import_module('hed'); 
    utilModule = py.importlib.import_module('hed.tools.analysis.annotation_util'); 
    if py.isinstance(events, hedModule.TabularInput)
        tabObj = events;
        return;
    end
    if isempty(sidecar) || (isa(sidecar, 'py.NoneType') && sidecar == py.None)
        sidecarObj = py.None;
    else
        sidecarObj = getSidecar(sidecar);
    end
    if ischar(events) || isstring(events)
        tabObj = utilModule.str_to_tabular(events, sidecarObj);
    else
        throw(MException('getTabularInput:Invalid input'))
    end
end
