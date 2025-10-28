HED API reference
=================

HED Tools
---------

.. mat:module:: hedmat.hedtools

The HED tools module provides MATLAB interfaces for HED validation and operations.

.. mat:function:: HedTools

   Abstract base class for HED tools implementations.

.. mat:function:: HedToolsPython

   Concrete class using direct calls to Python for HedTools interface.

.. mat:function:: HedToolsService

   Creates a connection object for the HED web online services.


Event Remodeling Demos
----------------------

.. mat:module:: hedmat.remodeling_demos

Examples demonstrating event data remodeling and processing.

- `remodel.m` - Main remodeling demonstration
- `remodelBackup.m` - Backup remodeling state
- `remodelRestore.m` - Restore remodeling state
- `runRemodelDemos.m` - Run all remodeling demonstrations


Web Services Demos
------------------

.. mat:module:: hedmat.web_services_demos

Examples demonstrating HED web service usage.

- `demoEventRemodelingServices.m` - Event remodeling services
- `demoEventSearchServices.m` - Event search services
- `demoEventServices.m` - Event services
- `demoGetServices.m` - Get services
- `demoLibraryServices.m` - Library services
- `demoSidecarServices.m` - Sidecar services
- `demoSpreadsheetServices.m` - Spreadsheet services
- `demoStringServices.m` - String services
- `exampleGenerateSidecar.m` - Example: Generate sidecar
- `runAllDemos.m` - Run all demonstrations


Utilities
---------

.. mat:module:: hedmat.utilities

Helper functions for common operations.

- `events2string.m` - Convert events to string format
- `filterDirectories.m` - Filter directories
- `filterFiles.m` - Filter files
- `getFileList.m` - Get file list
- `rectify_events.m` - Rectify events
- `separateFiles.m` - Separate files
- `str2lines.m` - Convert string to lines
