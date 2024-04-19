function hedSchema = getHedSchema(hedVersion)
% Return a HedSchema or HedSchemaGroup object based on hedVersion
% 
% Parameters:
%    hedVersion  - a single string or a cell array of strings representing
%                  the HED schema version.
%
% Returns:
%     hedSchema - A hedSchema object
%
    py.importlib.import_module('hed');
    
    hedSchema = py.hed.schema.load_schema_version(hedVersion);