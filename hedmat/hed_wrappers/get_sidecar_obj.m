function sidecar_obj = get_sidecar_obj(sidecar)
% Returns a HEDTools Sidecar object extracted from input.
% 
% Parameters:
%    sidecar - Sidecar object, string, struct or char
%
% Returns:
%     sidecar_obj - a HEDTools Sidecar object.
%

    hmod = py.importlib.import_module('hed');
    umod = py.importlib.import_module('hed.tools.analysis.annotation_util');   
    if py.isinstance(sidecar, hmod.Sidecar)
        sidecar_obj = sidecar;
    elseif ischar(sidecar)
        sidecar_obj = umod.strs_to_sidecar(sidecar);
    elseif isstring(sidecar)
        sidecar_obj = umod.strs_to_sidecar(char(sidecar));
    elseif isstruct(sidecar)
        sidecar_obj = umod.strs_to_sidecar(jsonencode(sidecar));
    else
        throw(MException('get_sidecar_obj:BadInputFormat', ...
            'Sidecar must be char, string, struct, or Sidecar'));
    end
