function sidecarObj = getSidecar(sidecar)
% Returns a HEDTools Sidecar object extracted from input.
% 
% Parameters:
%    sidecar - Sidecar object, string, cell array
%    srate - the EEG sampling rate in Hz
%
% Returns:
%     eventTable - a table representing the events structure
%
% Notes:  If events doesn't have an onset column, it adds it based on
% the latency column. It converts columns other than 
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
