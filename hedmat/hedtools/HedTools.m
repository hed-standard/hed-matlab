classdef HedTools < handle
    % base
    
    properties

    end
    
    methods

    end

    methods (Static)
        function sidecar = formatSidecar(sidecarIn)
            % Convert the sidecar to a char array if necessary.
            %
            % Parameters:
            %    sidecarIn - a sidecar as a char, string, or struct
            %
            % Returns:
            %    sidecar converted to a char.
            if ischar(sidecarIn)
                sidecar = sidecarIn;
            elseif isstring(sidecarIn)
                sidecar = char(sidecarIn);
            elseif isstruct(sidecarIn)
                sidecar = jsonencode(sidecarIn);
            else
                throw(MException('HedToolsFormatSidecar:BadSidecarFormat', ...
                    'Sidecar must be char, string, or struct'));
            end
        end

        function events = formatEvents(eventsIn)
            % Convert eventsIn to a char array if necessary.
            %
            % Parameters:
            %    eventsIn - events as a char, string, or struct
            %
            % Returns:
            %    events converted to a char.
            
            if ischar(eventsIn)
                events = eventsIn;
            elseif isstring(eventsIn)
                events = char(eventsIn);
            elseif isstruct(eventsIn)
                events = char(events2string(eventsIn));
            else
                throw(MException('HedToolsFormatEvents:BadEventsFormat', ...
                    'events must be string, char, or struct'))
            end
        end
    end

    methods (Abstract)
        annotations = getHedAnnotations(obj, eventsIn, sidecar, ...
            removeTypesOn, includeContext, replaceDefs);

        factors = getHedFactors(obj, annotations, queries);

        issueString = validateEvents(obj, eventsIn, sidecar, checkWarnings);
        
        issueString = validateSidecar(obj, sidecar, checkWarnings);

        issueString = validateTags(obj, hedtags, checkWarnings);
        
        resetHedVersion(obj, hedVersion)
    end

end

