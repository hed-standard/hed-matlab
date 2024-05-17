classdef HedToolsBase < handle
    % base
    
    properties

    end
    
    methods
        function obj = HedToolsBase()
            % Interface for the HED tools class

        end
    end

    methods (Abstract)
         resetHedVersion(obj)
    end

end

