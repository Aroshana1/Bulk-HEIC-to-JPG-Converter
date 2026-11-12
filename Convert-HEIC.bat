@echo off
setlocal DisableDelayedExpansion
title Bulk HEIC to JPG

where magick >nul 2>nul
if errorlevel 1 (
    echo ImageMagick is required.
    echo Install it, then close and reopen this file:
    echo winget install --id ImageMagick.ImageMagick -e
    pause
    exit /b 1
)

set "SOURCE=%~1"
if not defined SOURCE (
    set /p "SOURCE=Paste your HEIC folder path here: "
)
set "SOURCE=%SOURCE:"=%"

if not exist "%SOURCE%\." (
    echo Folder not found.
    pause
    exit /b 1
)

set "DEST=%SOURCE%\JPG"
if not exist "%DEST%\." mkdir "%DEST%"
if not exist "%DEST%\." (
    echo Cannot create the JPG output folder.
    pause
    exit /b 1
)

for %%F in ("%SOURCE%\*.heic") do (
    if exist "%%~fF" if not exist "%%~fF\" (
        if exist "%DEST%\%%~nF.jpg" (
            echo SKIPPED: %%~nxF - JPG already exists
        ) else (
            echo Converting: %%~nxF
            magick "%%~fF[0]" -auto-orient -sampling-factor 4:4:4 -quality 100 "%DEST%\%%~nF.jpg"
            if errorlevel 1 (
                echo FAILED: %%~nxF
                if exist "%DEST%\%%~nF.jpg" del "%DEST%\%%~nF.jpg"
            ) else (
                set "HEIC_INPUT=%%~fF"
                set "JPEG_OUTPUT=%DEST%\%%~nF.jpg"
                powershell -NoProfile -Command "try { $s = Get-Item -LiteralPath $env:HEIC_INPUT; $d = Get-Item -LiteralPath $env:JPEG_OUTPUT; $d.CreationTimeUtc = $s.CreationTimeUtc; $d.LastWriteTimeUtc = $s.LastWriteTimeUtc } catch { Write-Warning 'Could not copy file dates.' }"
            )
        )
    )
)

echo.
echo Finished. Check above for any failures.
echo JPG folder: "%DEST%"
echo Your original HEIC files were kept.
pause