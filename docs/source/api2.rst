HED API reference
=================

HED Tools
---------

The HED tools module provides MATLAB interfaces for HED validation and operations.

HedTools (Abstract Base Class)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. mat:autoclass:: hedtools.HedTools
   :members:
   :show-inheritance:

HedToolsPython
~~~~~~~~~~~~~~

.. mat:autoclass:: hedtools.HedToolsPython
   :members:
   :show-inheritance:
   :inherited-members:

HedToolsService
~~~~~~~~~~~~~~~

.. mat:autoclass:: hedtools.HedToolsService
   :members:
   :show-inheritance:
   :inherited-members:

getHedTools
~~~~~~~~~~~

.. mat:autofunction:: hedtools.getHedTools


Event Remodeling Demos
----------------------

Examples demonstrating event data remodeling and processing.

.. mat:autofunction:: remodeling_demos.remodel

.. mat:autofunction:: remodeling_demos.remodelBackup

.. mat:autofunction:: remodeling_demos.remodelRestore

.. mat:autofunction:: remodeling_demos.runRemodelDemos


Web Services Demos
------------------

Examples demonstrating HED web service usage.

.. mat:autofunction:: web_services_demos.demoEventRemodelingServices

.. mat:autofunction:: web_services_demos.demoEventSearchServices

.. mat:autofunction:: web_services_demos.demoEventServices

.. mat:autofunction:: web_services_demos.demoGetServices

.. mat:autofunction:: web_services_demos.demoLibraryServices

.. mat:autofunction:: web_services_demos.demoSidecarServices

.. mat:autofunction:: web_services_demos.demoSpreadsheetServices

.. mat:autofunction:: web_services_demos.demoStringServices

.. mat:autofunction:: web_services_demos.exampleGenerateSidecar

.. mat:autofunction:: web_services_demos.getDemoData

.. mat:autofunction:: web_services_demos.getHostOptions

.. mat:autofunction:: web_services_demos.getRequestTemplate

.. mat:autofunction:: web_services_demos.getSessionInfo

.. mat:autofunction:: web_services_demos.outputReport

.. mat:autofunction:: web_services_demos.runAllDemos

.. mat:autofunction:: web_services_demos.runDemo


Utilities
---------

Helper functions for common operations.

.. mat:autofunction:: utilities.events2string

.. mat:autofunction:: utilities.filterDirectories

.. mat:autofunction:: utilities.filterFiles

.. mat:autofunction:: utilities.getFileList

.. mat:autofunction:: utilities.rectify_events

.. mat:autofunction:: utilities.separateFiles

.. mat:autofunction:: utilities.str2lines
