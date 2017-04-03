# Enable Windows features for development, including the Linux subsystem
# Bash for windows

$features = choco list --source windowsfeatures
if ($features | Where-Object {$_ -like "*Linux*"})
{
    choco install Microsoft-Windows-Subsystem-Linux           --source windowsfeatures --limitoutput
}

# VMWare Workstation won't work if Hyper-V is enabled, so it's one or the other
# # windows containers
# Enable-WindowsOptionalFeature -Online -FeatureName containers -All

# # hyper-v (required for windows containers)
# Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All