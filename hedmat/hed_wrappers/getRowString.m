function rowString = getRowString(cells)

    cellsAsStrings = cell(size(cells));
    for k = 1:length(cells)
        x = cells{k}
        cellsAsStrings{k} = getString(cells{k});
    end
    rowString = strjoin(string(cellsAsStrings), '\t');
end

function elString = getString(element)
    if any(ismissing(element)) || any(isempty(element))
        elString = "n/a";
    elseif any(isnumeric(element) & isnan(element))
        elString = "n/a";
    else
        elString = string(element);
    end  
end   

   