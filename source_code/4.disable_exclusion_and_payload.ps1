# Define the project root path and extraction folder
$projectRoot = $PSScriptRoot
$extractPath = "$projectRoot\extraction"

# Function to remove the extraction folder
Function Remove-ExtractionFolder {
    if (Test-Path $extractPath) {
        Remove-Item -Path $extractPath -Recurse -Force
        Write-Host "The extraction folder has been deleted." -ForegroundColor Green
    } else {
        Write-Host "The extraction folder does not exist." -ForegroundColor Yellow
    }
}

# Function to disable all Windows Defender exclusions
Function Disable-WindowsDefenderExclusions {
    # Get all Windows Defender exclusions
    $defenderExclusions = Get-MpPreference | Select-Object -ExpandProperty ExclusionPath

    # If exclusions exist
    if ($defenderExclusions) {
        # Disable all exclusions
        foreach ($exclusion in $defenderExclusions) {
            Remove-MpPreference -ExclusionPath $exclusion
            Write-Host "Exclusion removed: $exclusion" -ForegroundColor Yellow
        }
    } else {
        Write-Host "No exclusions found in Windows Defender." -ForegroundColor Yellow
    }
}

# Execute both functions
Disable-WindowsDefenderExclusions
Remove-ExtractionFolder

Write-Host "Process completed." -ForegroundColor Green
