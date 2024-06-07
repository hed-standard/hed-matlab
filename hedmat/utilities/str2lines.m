function outStrings = str2lines(inString)
% Splits a string based on \n into cell entries. 
%  
%   Parameters:
%      inString - 
    inString = char(inString);
    if isempty(inString)
        outStrings = {};
    else
        inString = strrep(inString, '\r\n', '\n');
        outStrings = split(inString, '\n');
        if endsWith(inString, '\n')
            outStrings = outStrings(1:end-1);
        end
    end
end

