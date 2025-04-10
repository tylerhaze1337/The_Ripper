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
