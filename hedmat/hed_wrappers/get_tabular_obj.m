function tabular_obj = get_tabular_obj(events, sidecar, sampling_rate)
% Returns a HED TabularInput object representing events or other columnar item.
% 
% Parameters:
%    events - string, struct, or TabularInput for tabular data.
%    sidecar - Sidecar object, string, or struct or py.None
%    sampling_rate - optional sampling rate if struct doesn't have onset
%
% Returns:
%     tabular_obj - HEDTools TabularInput object representing tabular data.
%
    hmod = py.importlib.import_module('hed'); 
    umod = py.importlib.import_module('hed.tools.analysis.annotation_util'); 
    if py.isinstance(events, hmod.TabularInput)
        tabular_obj = events;
        return;
    end
    if isempty(sidecar) || (isa(sidecar, 'py.NoneType') && sidecar == py.None)
        sidecar_obj = py.None;
    else
        sidecar_obj = get_sidecar_obj(sidecar);
    end
    if nargin == 1
        sampling_rate = NaN;
    end
    if isstruct(events)
        events = struct2string(rectify_events(events, sampling_rate));
        tabular_obj = umod.str_to_tabular(events, sidecar_obj);
    elseif ischar(events) || isstring(events)
        tabular_obj = umod.str_to_tabular(events, sidecar_obj);
    else
        throw(MException('getTabularInput:Invalid input'))
    end
end
