$Boxstarter.RebootOk=$true
$Boxstarter.NoPassword=$false
$Boxstarter.AutoLogin=$true

function Install-WindowsUpdateIfEnabled
{
    if (Test-Path env:\BoxStarter:SkipWindowsUpdate)
    {
        return
    }

	Enable-MicrosoftUpdate
	Install-WindowsUpdate -AcceptEula
	if (Test-PendingReboot) { Invoke-Reboot }
}

function Create-PackageFromScript([string]$path)
{
    $hash = (get-filehash $path).Hash
    $packageName = "boxstarter.temp." + (get-item $path).BaseName + "." + $hash.Substring(0, 10)

    New-PackageFromScript $path $packageName

    return $packageName
}

function Get-PackageScripts 
{
    Get-ChildItem (Join-Path -Path $PSScriptRoot -ChildPath "packages\*.*") -include "add_languages.ps1"
}

function Get-Packages
{
    $packages = @()
    foreach ($script in Get-PackageScripts) {
        $packages += Create-PackageFromScript $script
    }

    return $packages
}

function Install-Package([string]$packageName)
{
    Write-BoxstarterMessage "Installing $packageName"
    Install-BoxstarterPackage $packageName
    if (Test-PendingReboot) { Invoke-Reboot }
}

Write-BoxstarterMessage "Updating Windows prior to installing packages..."
Install-WindowsUpdateIfEnabled

# disable chocolatey default confirmation behaviour (no need for --yes)
choco feature enable --name=allowGlobalConfirmation

Write-BoxstarterMessage "Installing packages..."

$packages = Get-Packages
foreach ($package in $packages) {
    Install-Package $package
}

# install chocolatey as last choco package
choco install chocolatey --limitoutput

# re-enable chocolatey default confirmation behaviour
choco feature disable --name=allowGlobalConfirmation

if (Test-PendingReboot) { Invoke-Reboot }

# set HOME to user profile for git
[Environment]::SetEnvironmentVariable("HOME", $env:UserProfile, "User")

# rerun windows update after we have installed everything
Write-BoxstarterMessage "Updating Windows again after installing packages..."

Install-WindowsUpdateIfEnabled
