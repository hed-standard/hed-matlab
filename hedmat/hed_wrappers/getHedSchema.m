function hedSchema = getHedSchema(schema)
% Return a HedSchema or HedSchemaGroup object based on hedVersion
% 
% Parameters:
%    schema - a single string or a cell array of strings representing
%           the HED schema version or a schema object.
%
% Returns:
%     hedSchema - A hedSchema object
%
   hedModule = py.importlib.import_module('hed');

   if py.isinstance(schema, hedModule.HedSchema) || ...
       py.isinstance(schema, hedModule.HedSchemaGroup)
       hedSchema = schema;
   elseif ischar(schema)
       hedSchema = hedModule.schema.load_schema_version(schema);
   elseif iscell(schema)
       hedSchema = hedModule.schema.load_schema_version(py.list(schema));
   else
       hedSchema = py.None;
   end