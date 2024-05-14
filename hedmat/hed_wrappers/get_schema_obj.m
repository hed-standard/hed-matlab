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
   hmod = py.importlib.import_module('hed');
   if ischar(schema)
       schema_obj = hmod.load_schema_version(schema);
   elseif iscell(schema)
       schema_obj = hmod.load_schema_version(py.list(schema));
   elseif py.isinstance(schema, hmod.HedSchema) || ...
       py.isinstance(schema, hmod.HedSchemaGroup)
       schema_obj = schema;
   else
       schema_obj = py.None;
   end