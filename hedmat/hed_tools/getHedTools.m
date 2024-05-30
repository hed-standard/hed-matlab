function hed = getHedTools(hedVersion, host)
% Factory method that returns either a HedService or a HedDirect object
    if nargin == 2
        hed = HedToolsService(hedVersion, host);
    else
        hed = HedToolsPython(hedVersion);
    end
end

