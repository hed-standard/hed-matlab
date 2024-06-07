function hed = getHedTools(hedVersion, host)
% Factory method that returns either HedToolsService or HedToolsPython
%
% Parameters:
%    hedVersion - char or cell array with HED version to be used.
%    host - web address of service if HedToolsService is to be used.
    if nargin == 2 && ~isempty(host)
        hed = HedToolsService(hedVersion, host);
    else
        hed = HedToolsPython(hedVersion);
    end
end

