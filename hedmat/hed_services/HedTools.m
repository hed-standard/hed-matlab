classdef HedTools < handle
    % base
    
    properties

    end
    
    methods

    end

    methods (Static)
        function sidecar = formatSidecar(sidecar_in)
            % Convert the sidecar to a char array if necessary.
            %
            % Parameters:
            %    sidecar - a sidecar as a 
            if ischar(sidecar_in)
                sidecar = sidecar_in;
            elseif isstring(sidecar_in)
                sidecar = char(sidecar_in);
            elseif isstruct(sidecar_in)
                sidecar = jsonencode(sidecar_in);
            else
                throw(MException('HedTools:BadSidecarFormat', ...
                   'Sidecar must be char, string, or struct'));
            end
        end
    end

    methods (Abstract)
         resetHedVersion(obj)
    end

end

