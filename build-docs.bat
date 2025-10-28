@echo off
echo Activating virtual environment...
call .venv\Scripts\activate.bat

echo.
echo Installing/updating dependencies...
pip install -r docs/requirements.txt

echo.
echo Patching sphinxcontrib-matlabdomain...
python docs/patch_matlabdomain.py

echo.
echo Building documentation...
sphinx-build -b html docs/source docs/_build/html

echo.
echo Documentation built successfully!
echo Static files are in: docs/_build/html/
echo.
echo To view locally, run: serve-sphinx.bat
pause
