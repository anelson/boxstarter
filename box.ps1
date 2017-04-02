. (Join-Path -Path $PSScriptRoot -ChildPath 'functions.ps1')

$Boxstarter.RebootOk=$true
$Boxstarter.NoPassword=$false
$Boxstarter.AutoLogin=$true

Write-BoxstarterMessage "Updating Windows prior to installing packages..."
Install-WindowsUpdateIfEnabled

# disable chocolatey default confirmation behaviour (no need for --yes)
choco feature enable --name=allowGlobalConfirmation

Write-BoxstarterMessage "Installing packages..."

$scripts = Get-Scripts
foreach ($script in $scripts) {
    Install-Script $script
}

# install chocolatey as last choco package
choco install chocolatey --limitoutput

# re-enable chocolatey default confirmation behaviour
choco feature disable --name=allowGlobalConfirmation

if (Test-PendingReboot) { Invoke-Reboot }

# set HOME to user profile for git
[Environment]::SetEnvironmentVariable("HOME", $env:UserProfile, "User")

Clear-Checkpoints

# rerun windows update after we have installed everything
Write-BoxstarterMessage "Updating Windows again after installing packages..."

Install-WindowsUpdateIfEnabled
