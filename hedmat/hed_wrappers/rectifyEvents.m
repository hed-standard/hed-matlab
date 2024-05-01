function eventsNew= rectifyEvents(eventStruct, samplingRate)
% Makes sure that an EEG.event structure has onset and duration fields.
%
%  Parameters:
%      eventStruct - (Input/Output) EEG.event structure adjusted.
%      samplingRate - Sampling rate needed to convert latency to onset.
%  
    fields = fieldnames(eventStruct);
    if  ~ismember('duration', fields)
        [eventStruct.duration] = deal(NaN);
    end
    if ~ismember('onset', fields)
       latency = [eventStruct.latency];
       onset = (double(latency) - 1.0)./double(samplingRate);
       onsetCells = num2cell(onset);
       [eventStruct.onset] = onsetCells{:};
    end
    fields = fieldnames(eventStruct);
    fieldsNew = setdiff(fields(:)', {'onset', 'duration'});
    fieldsNew = [{'onset', 'duration'}, fieldsNew];
    eventsNew = orderfields(eventStruct, fieldsNew);
end