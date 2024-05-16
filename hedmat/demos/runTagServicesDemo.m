%% This demo shows how to use webservices to validate HED issstrings
host = 'https://hedtools.org/hed_dev';
hed = HedService(host);
schema_version = '8.2.0';
%% Validate a list of 3 valid HED strings (ignore warnings)
good_strings = {'Red, Blue/Apple', 'Sensory-event', 'Agent-action'};
issues1 = hed.validate_hedtags(good_strings, ...
                schema_version, false, struct());

%% Validate a list of 3 valid HED strings (but one has a warning)
issues2 = hed.validate_hedtags(good_strings, ...
                schema_version, true, struct());

%% Validate a list of 3 invalid HED strings (but one has a warning)
bad_strings = {'Green, Bunch', 'Alpha, Betaissu', 'FooBar, Sensory-event'};
issues3 = hed.validate_hedtags(bad_strings, ...
                schema_version, true, struct());
