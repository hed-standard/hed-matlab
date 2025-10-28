@echo off
echo Activating virtual environment...
call .venv\Scripts\activate.bat

echo.
if not exist "docs\_build\html" (
    echo ERROR: Documentation has not been built yet!
    echo Please run: build-docs.bat
    echo.
    pause
    exit /b 1
)

echo Starting local Sphinx documentation server...
echo Open your browser to: http://localhost:8000
echo Press Ctrl+C to stop the server

cd /d "%~dp0docs\_build\html"
python -m http.server 8000

