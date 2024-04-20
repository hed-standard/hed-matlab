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

   if ~py.isinstance(hedSchema, hedModule.HedSchema) && ...
       ~py.isinstance(hedSchema, hedModule.HedSchemaGroup)
        hedSchema = getHedSchema(hedSchema);
    end
    hedSchema = py.hed.schema.load_schema_version(hedVersion);