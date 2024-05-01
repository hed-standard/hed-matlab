

events1(3) = struct('onset', 3.2, 'duration', NaN, 'latency', 6234, ...
                 'response', 2.1, 'type', 'apple');
events1(2) = struct('onset', 2.2, 'duration', NaN, 'latency', 5234, ...
                 'response', NaN, 'type', 'pear');
events1(1) = struct('onset', 1.1, 'duration', NaN,  'latency', 4234, ...
                 'response', 1.5, 'type', 'banana');


eventsNew = rectifyEvents(events1, 100.0);