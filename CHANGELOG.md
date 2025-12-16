## Release 1.0.0 August 3, 2024 - Initial release

- Implements a base class `HedTools` with following interface:
  - `generateSidecar`
  - `getHedAnnotations`
  - \`searchHed
  - `validateEvents`
  - `validateSidecar`
  - `validateTags`
  - `resetHedVersion`
- Provides two implementations of the interface:
  - `HedToolsService` - calls web services to perform the operations
  - `HedToolsPython` - calls local installed Python libraries to perform the operations
