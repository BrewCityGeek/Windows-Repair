# =================================================================================
#
# NAME: Repair-Windows.ps1
#
# AUTHOR: Gemini
#
# COMMENT: This script automates the process of repairing Windows system files
#          by running DISM and SFC commands. It includes error checking to
#          ensure each step completes successfully before proceeding.
#          It must be run as an Administrator.
#
# =================================================================================

# Step 1: Check for Administrator Privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script requires Administrator privileges to run."
    Write-Host "Please right-click the script file and select 'Run as Administrator'."
    Read-Host "Press any key to exit..."
    exit
}

# Clear the screen for a clean output
Clear-Host

# --- Script Header ---
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "     Windows System File Repair Utility" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host
Write-Host "This script will now run DISM and SFC to find and fix system file corruption." -ForegroundColor White
Write-Host "The process can take 15-30 minutes or more. Please do not close this window." -ForegroundColor Yellow
Write-Host

# Function to pause and exit on error
function Pause-And-Exit {
    Write-Host
    Read-Host "Press ENTER to exit the script."
    exit
}


# --- Run DISM CheckHealth ---
Write-Host "--- Step 1 of 4: Scanning component store with DISM /CheckHealth ---" -ForegroundColor Green
DISM /Online /Cleanup-Image /CheckHealth

if ($LASTEXITCODE -ne 0) {
    Write-Error "DISM /CheckHealth failed with exit code $LASTEXITCODE. Cannot continue."
    Pause-And-Exit
}
Write-Host "CheckHealth complete." -ForegroundColor Green
Write-Host


# --- Run DISM ScanHealth ---
Write-Host "--- Step 2 of 4: Scanning component store with DISM /ScanHealth ---" -ForegroundColor Green
DISM /Online /Cleanup-Image /ScanHealth

if ($LASTEXITCODE -ne 0) {
    Write-Error "DISM /ScanHealth failed with exit code $LASTEXITCODE. Cannot continue."
    Pause-And-Exit
}
Write-Host "ScanHealth complete." -ForegroundColor Green
Write-Host


# --- Run DISM RestoreHealth ---
Write-Host "--- Step 3 of 4: Repairing Windows image with DISM /RestoreHealth ---" -ForegroundColor Green
DISM /Online /Cleanup-Image /RestoreHealth

if ($LASTEXITCODE -ne 0) {
    Write-Error "DISM /RestoreHealth failed with exit code $LASTEXITCODE. Cannot continue."
    Pause-And-Exit
}
Write-Host "RestoreHealth complete." -ForegroundColor Green
Write-Host


# --- Run SFC /scannow ---
Write-Host "--- Step 4 of 4: Scanning system files with SFC /scannow ---" -ForegroundColor Green
sfc /scannow

if ($LASTEXITCODE -ne 0) {
    Write-Error "SFC /scannow failed with exit code $LASTEXITCODE."
    Pause-And-Exit
}
Write-Host "SFC scan complete." -ForegroundColor Green
Write-Host


# --- Final Message ---
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "All repair tasks have finished successfully." -ForegroundColor Cyan
Write-Host "It is highly recommended you restart your computer now." -ForegroundColor Yellow
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host
Read-Host "Press ENTER to exit the script."