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

# Enable the Blank screensaver, require password
$regkeypath = "HKCU:\Control Panel\Desktop"
Set-ItemProperty -Path $regkeypath -Name "ScreenSaveActive"  -Value 1
Set-ItemProperty -Path $regkeypath -Name "ScreenSaverIsSecure" -Value 1
Set-ItemProperty -Path $regkeypath -Name "ScreenSaveTimeOut"  -Value 600 # 10 minutes
Set-ItemProperty -Path $regkeypath -Name "SCRNSAVE.EXE" -Value "$($env:SystemRoot)\system32\scrnsave.scr" # blank

Write-BoxstarterMessage "Configured"
