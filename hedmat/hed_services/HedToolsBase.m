classdef HedToolsBase
    % base
    
    properties
        hedVersion
    end
    
    methods
        function obj = HedToolsBase()
            % Interface for the HED tools class
           
        end
    end

    methods (Abstract)
         setHedVersion(obj)
    end

end

