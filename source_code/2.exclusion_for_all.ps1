# Function to add an exclusion for all connected storage devices
Function Add-ExclusionForAllDrives {
    # Retrieve all connected drives (internal, external, removable, etc.)
    $allDrives = Get-WmiObject -Class Win32_LogicalDisk

    foreach ($drive in $allDrives) {
        # Exclude network drives and drives without a letter
        if ($drive.DriveType -ne 4 -and $drive.DeviceID) {
            # Add a '\' at the end of the drive to ensure the path is complete
            $driveLetter = $drive.DeviceID + '\'
            Write-Host "Adding an exclusion for drive: $driveLetter" -ForegroundColor Yellow
            # Add the exclusion for this drive
            Add-MpPreference -ExclusionPath $driveLetter
        }
    }
}

# Add exclusions for all connected drives
Add-ExclusionForAllDrives
