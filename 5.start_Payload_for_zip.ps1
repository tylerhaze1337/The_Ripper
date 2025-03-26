# Define the project root path
$projectRoot = $PSScriptRoot

# Folder where the files will be extracted
$extractPath = "$projectRoot\extraction"

# Create the extraction folder if it doesn't exist
if (-not (Test-Path $extractPath)) {
    New-Item -ItemType Directory -Force -Path $extractPath
}

# Get all .zip files in the project root folder
$zipFiles = Get-ChildItem -Path $projectRoot -Filter "*.zip"

# Loop through each .zip file
foreach ($zipFile in $zipFiles) {
    Write-Host "Extracting archive: $zipFile" -ForegroundColor Yellow

    # Extract the content of the .zip file
    Expand-Archive -Path $zipFile.FullName -DestinationPath $extractPath -Force

    # Pause for 4 seconds to allow the extraction process to finish
    Write-Host "Pausing after extraction to allow time for the process to complete." -ForegroundColor Yellow
    Start-Sleep -Seconds 4

    # Get all extracted files (all files, without filtering by extension)
    $extractedFiles = Get-ChildItem -Path $extractPath

    # Loop through each extracted file
    foreach ($file in $extractedFiles) {
        Write-Host "Executing: $file" -ForegroundColor Green

        # Check if the file is not a directory
        if ($file.PSIsContainer) {
            Write-Host "The file $file is a directory and will be ignored." -ForegroundColor Yellow
            continue
        }

        try {
            # Run the file, regardless of its extension (except for cases like .zip)
            $process = Start-Process -FilePath $file.FullName -PassThru
            # Wait for the process to exit
            $process.WaitForExit()

            Write-Host "The file $file has finished executing." -ForegroundColor Green
        }
        catch {
            Write-Host "Error running the file " -ForegroundColor Red
        }

        # Delete the file after execution
        Remove-Item -Path $file.FullName -Force
        Write-Host "The file $file has been deleted." -ForegroundColor Green
    }
}

Write-Host "Processing complete." -ForegroundColor Green
