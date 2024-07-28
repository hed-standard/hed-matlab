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

        sidecar = generateSidecar(obj, eventsIn, valueColumns, skipColumns);
        
        annotations = getHedAnnotations(obj, eventsIn, sidecar, varargin);

        factors = searchHed(obj, annotations, queries);

        issues = validateEvents(obj, eventsIn, sidecar, varargin);
        
        issues = validateSidecar(obj, sidecar, varargin);

        issues = validateTags(obj, hedtags, varargin);
        
        resetHedVersion(obj, hedVersion)
    end

end

