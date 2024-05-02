function schema_obj = get_schema_obj(schema)
% Return a HedSchema or HedSchemaGroup object based on hedVersion
% 
% Parameters:
%    schema - a single string or a cell array of strings representing
%           the HED schema version or a schema object.
%
% Returns:
%     schema_obj - A hedSchema object
%
   hedModule = py.importlib.import_module('hed');

   if py.isinstance(schema, hedModule.HedSchema) || ...
       py.isinstance(schema, hedModule.HedSchemaGroup)
       schema_obj = schema;
   elseif ischar(schema)
       schema_obj = hedModule.schema.load_schema_version(schema);
   elseif iscell(schema)
       schema_obj = hedModule.schema.load_schema_version(py.list(schema));
   else
       schema_obj = py.None;
   end