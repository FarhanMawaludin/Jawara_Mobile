@echo off
cls
echo.
echo ========================================
echo   JAWARA MOBILE - TEST COVERAGE
echo ========================================
echo.

REM Clean previous coverage HTML
if exist coverage\html (
    echo Cleaning previous coverage...
    rmdir /s /q coverage\html
    echo Previous coverage cleaned!
    echo.
)

REM Create coverage/html folder
if not exist coverage\html (
    echo Creating coverage\html folder...
    mkdir coverage\html
    echo Folder created!
    echo.
)

REM Run tests from lib/test directory
echo [1/5] Running tests...
echo.
flutter test --coverage

REM Check if coverage data generated
if not exist coverage\lcov.info (
    echo.
    echo ========================================
    echo   ERROR: No coverage data generated!
    echo ========================================
    echo.
    echo Possible reasons:
    echo - No tests found in lib/test
    echo - Tests failed to run
    echo - Coverage generation failed
    echo.
    pause
    exit /b 1
)

echo.
echo Coverage data generated successfully!
echo.

REM Install coverage tool
echo [2/5] Installing coverage tool...
call dart pub global activate coverage
echo.

REM Generate HTML report
echo [3/5] Generating HTML report...
call dart pub global run coverage:genhtml coverage\lcov.info -o coverage\html
echo.

REM Check if HTML generated
if not exist coverage\html\index.html (
    echo.
    echo ERROR: HTML report generation failed!
    pause
    exit /b 1
)

echo HTML report generated successfully!
echo.

REM Copy custom style
echo [4/5] Applying custom UI...
if exist coverage\style.css (
    copy /Y coverage\style.css coverage\html\style.css > nul
    echo ✓ Custom style applied!
) else (
    echo ⚠ Warning: coverage\style.css not found
    echo   Using default genhtml style
)
echo.

REM Create custom index page (optional enhancement)
echo [5/5] Creating enhanced index...
call :create_enhanced_index
echo ✓ Enhanced index created!
echo.

echo ========================================
echo   ✅ COVERAGE REPORT READY!
echo ========================================
echo.
echo Report location: coverage\html\index.html
echo Opening browser...
echo.

REM Open coverage report
start coverage\html\index.html

echo.
echo Press any key to exit...
pause > nul
exit /b 0

REM Function to create enhanced index
:create_enhanced_index
(
echo ^<!DOCTYPE html^>
echo ^<html lang="en"^>
echo ^<head^>
echo   ^<meta charset="UTF-8"^>
echo   ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
echo   ^<title^>Coverage Report - Jawara Mobile^</title^>
echo   ^<link rel="stylesheet" href="style.css"^>
echo   ^<style^>
echo     body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
echo     .banner { 
echo       background: linear-gradient(135deg, #667eea 0%%, #764ba2 100%%^); 
echo       color: white; 
echo       padding: 30px; 
echo       text-align: center; 
echo       margin-bottom: 30px;
echo     }
echo     .banner h1 { margin: 0; font-size: 2.5em; }
echo     .banner p { margin: 10px 0 0 0; opacity: 0.9; }
echo     .nav-link { 
echo       display: inline-block; 
echo       margin: 20px; 
echo       padding: 15px 30px; 
echo       background: #667eea; 
echo       color: white; 
echo       text-decoration: none; 
echo       border-radius: 8px; 
echo       font-weight: 600;
echo       transition: all 0.3s ease;
echo     }
echo     .nav-link:hover { 
echo       background: #764ba2; 
echo       transform: translateY(-2px^); 
echo       box-shadow: 0 4px 8px rgba(0,0,0,0.2^);
echo     }
echo     .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
echo     iframe { width: 100%%; height: 800px; border: none; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1^); }
echo   ^</style^>
echo ^</head^>
echo ^<body^>
echo   ^<div class="banner"^>
echo     ^<h1^>🎯 Test Coverage Report^</h1^>
echo     ^<p^>Jawara Mobile - Flutter Application^</p^>
echo   ^</div^>
echo   ^<div style="text-align: center;"^>
echo     ^<a href="index.html" class="nav-link" target="report-frame"^>📊 View Coverage Report^</a^>
echo     ^<a href="." class="nav-link"^>📁 Browse Files^</a^>
echo   ^</div^>
echo   ^<div class="container"^>
echo     ^<iframe name="report-frame" src="index.html"^>^</iframe^>
echo   ^</div^>
echo ^</body^>
echo ^</html^>
) > coverage\html\dashboard.html
exit /b 0