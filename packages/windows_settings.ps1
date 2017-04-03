Write-BoxstarterMessage "Configuring Windows options"

# Use PowerShell for command prompt when Win-X is pressed
Set-CornerNavigationOptions -EnableUsePowerShellOnWinX

# Configure explore to not be utterly retarded
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -DisableShowProtectedOSFiles -EnableShowFileExtensions

# Combining task bar buttons is incredibly annoying
Set-TaskbarOptions -Combine Never

# Change Power saving options (ac=plugged in dc=battery)
powercfg -change -monitor-timeout-ac 0 # My setup is such that if the monitors power off then the window layout is ruined
powercfg -change -monitor-timeout-dc 5
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 30
powercfg -change -disk-timeout-ac 0
powercfg -change -disk-timeout-dc 30
powercfg -change -hibernate-timeout-ac 0

# Disable Windows Defender real-time scanning
Set-MpPreference -DisableRealtimeMonitoring $true

# Do not consent to Windows Defender sending your data to MSFT
Set-MpPreference -SubmitSamplesConsent 0

# Do not enable cloud protection
Set-MpPreference -MAPSReporting 0

# Eastern time zone
#http://stackoverflow.com/questions/4235243/how-to-set-timezone-using-powershell
&"$env:windir\system32\tzutil.exe" /s "Eastern Standard Time"

$signature = @"
[DllImport("user32.dll")]
public static extern bool SystemParametersInfo(int uAction, int uParam, ref int lpvParam, int flags );
"@
 
$systemParamInfo = Add-Type -memberDefinition  $signature -Name ScreenSaver -passThru
 
Function Get-ScreenSaverTimeout
{
  [Int32]$value = 0
  $systemParamInfo::SystemParametersInfo(14, 0, [REF]$value, 0)
  $($value/60)
}
 
Function Set-ScreenSaverTimeout
{
  Param ([Int32]$value)
  $seconds = $value * 60
  [Int32]$nullVar = 0
  $systemParamInfo::SystemParametersInfo(15, $seconds, [REF]$nullVar, 2)
}

Function Enable-ScreenSaver
{
  [Int32]$enabled = $true
  [Int32]$nullVar = 0
  $systemParamInfo::SystemParametersInfo(0x11, $enabled, [REF]$nullVar, 2)
}

Function Enable-ScreenSaverSecure
{
  [Int32]$enabled = $true
  [Int32]$nullVar = 0
  $systemParamInfo::SystemParametersInfo(0x77, $enabled, [REF]$nullVar, 2)
}

# Enable the Blank screensaver, require password
# Note: editing the registry values alone seems not to make this change take effect
# Using the SystemParametersInfo calls seems to trigger the application of all of the settings
# The rundll32 invocation is probably not needed but it doesn't hurt.  There's scant documentation on how 
# to do these things in Windows so one must take a "this seems to work" approach
$regkeypath = "HKCU:\Control Panel\Desktop"
Set-ItemProperty -Path $regkeypath -Name "ScreenSaveActive"  -Value 1
Set-ItemProperty -Path $regkeypath -Name "ScreenSaverIsSecure" -Value 1
Set-ItemProperty -Path $regkeypath -Name "ScreenSaveTimeOut"  -Value 600 # 10 minutes
Set-ItemProperty -Path $regkeypath -Name "SCRNSAVE.EXE" -Value "$($env:SystemRoot)\system32\scrnsave.scr" # blank
rundll32.exe user32.dll, UpdatePerUserSystemParameters

Set-ScreenSaverTimeout 10 
Enable-ScreenSaver
Enable-ScreenSaverSecure

Write-BoxstarterMessage "Configured"
