function hedSchema = getHedSchema(hed)
% Return a HedSchema or HedSchemaGroup object based on hedVersion
% 
% Parameters:
%    hed  - a single string or a cell array of strings representing
%           the HED schema version or a schema object.
%
% Returns:
%     hedSchema - A hedSchema object
%
   hedModule = py.importlib.import_module('hed');

   if ~py.isinstance(hed, hedModule.HedSchema) && ...
       ~py.isinstance(hed, hedModule.HedSchemaGroup)
        hedSchema = hedModule.load_schema_version(hed);
   else
       hedSchema = hed;
   end