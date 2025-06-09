# Elevate to ensure admin context
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrator")) {
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}
 
# Update Winget
winget upgrade --all --accept-package-agreements --accept-source-agreements
 
# Install common dev tools
$packages = @(
    "Microsoft.VisualStudio.2022.Community",    # Visual Studio
    "Microsoft.VisualStudioCode",               # VS Code
    "Microsoft.Office",                         # Office 365 (depends on license)
    "Microsoft.Teams",                          # Teams desktop
    "Git.Git",                                   # Git for Windows
    "Google.Chrome",                            # Chrome
    "Microsoft.Edge",                           # Edge browser
    "Postman.Postman",                          # Postman
    "Microsoft.SQLServerManagementStudio",      # SSMS
    "OpenJS.NodeJS.LTS"                         # Node.js LTS
)
 
foreach ($pkg in $packages) {
    Write-Host "Installing $pkg..."
    winget install --id $pkg --accept-package-agreements --accept-source-agreements --silent
}
 
# Install Python 3.9 specifically
Write-Host "Installing Python 3.12.9..."
winget install --id Python.Python.3.12.9 --accept-package-agreements --accept-source-agreements --silent
 
# Set up Python environment
Write-Host "Setting up pip environment..."
$env:Path += ";$env:LocalAppData\\Programs\\Python\\Python39\\Scripts"
python -m pip install --upgrade pip
pip install virtualenv black flake8 requests pandas
 
Write-Host "All development tools installed."