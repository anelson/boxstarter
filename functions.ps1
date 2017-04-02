# Functions shared between multiple PowerShell scripts
$checkpointPrefix = 'BoxStarter:Checkpoint:'

function Get-CheckpointName
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $CheckpointName
    )
    return "$checkpointPrefix$CheckpointName"
}

function Set-Checkpoint
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $CheckpointName,

        [Parameter(Mandatory=$true)]
        [string]
        $CheckpointValue
    )

    $key = Get-CheckpointName $CheckpointName
    [Environment]::SetEnvironmentVariable($key, $CheckpointValue, "Machine") # for reboots
    [Environment]::SetEnvironmentVariable($key, $CheckpointValue, "Process") # for right now
}

function Get-Checkpoint
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $CheckpointName
    )

    $key = Get-CheckpointName $CheckpointName
    [Environment]::GetEnvironmentVariable($key, "Process")
}

function Clear-Checkpoints
{
    $checkpointMarkers = Get-ChildItem Env: | where { $_.name -like "$checkpointPrefix*" } | Select -ExpandProperty name
    foreach ($checkpointMarker in $checkpointMarkers) {
        [Environment]::SetEnvironmentVariable($checkpointMarker, '', "Machine")
        [Environment]::SetEnvironmentVariable($checkpointMarker, '', "Process")
    }
}

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

function Get-Scripts 
{
    Get-ChildItem (Join-Path -Path $PSScriptRoot -ChildPath "packages\*.*") -include "*.ps1"
}

function Install-Script([string]$path)
{
    $checkpointName = (get-item $path).BaseName
    $done = Get-Checkpoint -CheckpointName $checkpointName 
    if ($done) {
        return
    }
    
    Write-BoxstarterMessage "Invoking script $path"
    . $path 
    Write-BoxstarterMessage "Finished script $path"
    Set-Checkpoint -CheckpointName $checkpointName -CheckpointValue 1

    if (Test-PendingReboot) { Invoke-Reboot }
}