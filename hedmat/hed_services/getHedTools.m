function hed = getHedTools(host)
% Factory method that returns either a HedService or a HedDirect object
    if nargin == 1
        hed = HedToolsService(host);
    else
        hed = HedToolsPython();
    end
end

