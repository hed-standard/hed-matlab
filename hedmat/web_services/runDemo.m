%% Use this script to run an individual type of service.
% host = 'https://hedtools.org/hed';
host = 'http://127.0.0.1:5000/';
%host = 'https://hedtools.org/hed_dev';
%errors = demoLibraryServices(host);
%errors = demoSpreadsheetServices(host);
%errors = demoEventSearchServices(host);
errors = demoEventServices(host);
%errors = demoStringServices(host);
%errors = demoEventRemodelingServices(host);
%errors = demoSidecarServices(host);