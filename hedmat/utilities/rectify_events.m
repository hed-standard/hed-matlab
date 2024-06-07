function events_rectified = rectify_events(event_struct, sampling_rate)
% Makes sure that an EEG.event structure has onset and duration fields.
%
%  Parameters:
%      event_struct - (Input/Output) EEG.event structure adjusted.
%      sampling_rate - Sampling rate needed to convert latency to onset.
%  
    if ~isstruct(event_struct)
       throw(MException('rectify_events:InvalidEventStruct', ...
            'Requires event struct input'));
    end
    fields = fieldnames(event_struct);
    if  ~ismember('duration', fields)
        [event_struct.duration] = deal(NaN);
    end
    if ~ismember('onset', fields) && (nargin == 1 || isnan(sampling_rate))
        throw(MException('rectify_events:NeedSamplingRate', ...
            'Must have sampling rate to compute onset from latency'));
    elseif ~ismember('onset', fields) && ~ismember('latency', fields)
        throw(MException('rectify_events:MissingLatency', ...
            'Must have latency to compute onset'));
    elseif ~ismember('onset', fields)
       latency = [event_struct.latency];
       onset = (double(latency) - 1.0)./double(sampling_rate);
       onsetCells = num2cell(onset);
       [event_struct.onset] = onsetCells{:};
    end
    fields = fieldnames(event_struct);
    fields_new = setdiff(fields(:)', {'onset', 'duration'});
    fields_new = [{'onset', 'duration'}, fields_new];
    events_rectified = orderfields(event_struct, fields_new);
end