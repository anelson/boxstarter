$installScript = (Join-Path -Path $PSScriptRoot -ChildPath 'box.ps1')
$temporaryLauncherScript = Join-Path -Path $env:TEMP -ChildPath 'temp-boxstarter-launcher.ps1'

# The Boxstarter web launcher is very limited.  Whatever file name you pass to it, that file only is copied to a temporary
# directory and made into a temporary package.  That doesn't work for us since we have multiple files that interact with each other
# as a workaround, write a very simple one-line launcher script that will be made into a package and then calls our actual scripts
". $installScript" | Out-File $temporaryLauncherScript

$webLauncherUrl = "http://boxstarter.org/package/nr/url?$temporaryLauncherScript"
$edgeVersion = Get-AppxPackage -Name Microsoft.MicrosoftEdge

if ($edgeVersion)
{
    start microsoft-edge:$webLauncherUrl
}
else
{
    $IE=new-object -com internetexplorer.application
    $IE.navigate2($webLauncherUrl)
    $IE.visible=$true
}
