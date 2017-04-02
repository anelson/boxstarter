# Install some additional PowerShell modules, of most importance probably being a Nuget package provider
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'
Install-Module -Name Carbon
Install-Module -Name PowerShellHumanizer
Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Untrusted'
