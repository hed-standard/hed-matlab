function sidecarObj = getSidecar(sidecar)
% Returns a HEDTools Sidecar object extracted from input.
% 
% Parameters:
%    sidecar - Sidecar object, string, struct
%
% Returns:
%     sidecarObj - a HEDTools Sidecar object.
%

    hedModule = py.importlib.import_module('hed');
    utilModule = py.importlib.import_module('hed.tools.analysis.annotation_util');   
    if py.isinstance(sidecar, hedModule.Sidecar)
        sidecarObj = sidecar;
    elseif ischar(sidecar)
        sidecarObj = utilModule.strs_to_sidecar(sidecar);
    elseif isstruct(sidecar)
        sidecar1 = jsonencode(sidecar);
        sidecarObj = utilModule.strs_to_sidecar(sidecar1);
    else
        throw(MException('getSidecar:EmptySidecar', ...
            'Sidecar must not be empty'));
    end
