@echo off
setlocal
cd /d "%~dp0"

echo Packaging DesktopClock...

where python >nul 2>&1 || (echo Python not found & pause & exit /b 1)

python -c "import PyInstaller" >nul 2>&1 || pip install pyinstaller -q

if exist "dist" rmdir /s /q "dist"

python -m PyInstaller --onefile --windowed --name "DesktopClock" --distpath "dist" --workpath "build" --clean "main.py"

if exist "build" rmdir /s /q "build"
if exist "DesktopClock.spec" del /q "DesktopClock.spec"

if exist "dist\DesktopClock.exe" (
    echo Done: dist\DesktopClock.exe
) else (
    echo Packaging failed
    pause
    exit /b 1
)
pause
