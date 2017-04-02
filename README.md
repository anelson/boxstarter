# Automated Windows system setup

These are my scripts to configure a Windows development workstation using Boxstarter.

# Install on a new system

From a new system, you have to install Chocolatey first.  Then, in a PowerShell admin prompt, run:

`./bootstrap.ps1`

That will open a new Edge browser and launch the installation process.  Note it's important to do it that way because Boxstarter is more than just some scripts, it will have to reboot the system multiple times, and as long as you don't get in the way, it will log back in after each reboot and pick up where it left off.

# Add/modify the scripts

The scripts under `packages/` are regular PowerShell scripts that are packaged into Boxstarter packages as part of the scripting logic in `box.ps1`.  The scripts are named according to themes, like `standard_apps.ps1` installs things like Office, `windows_dev_tools.ps1` is Visual Studio, etc.  Add install commands to whichever script best fits the package you're adding, and re-run the installation process.  Alternatively, you can manually run the particular package script you've changed, from within the Boxstarter shell (a shortcut should be on your desktop once Boxstarter is installled).

It's worthwhile to adopt the discipline that when you want a software package installed, you update these scripts and install it that way.  It's a hassle, but if you keep that discipline then your mental resistance to repaving or moving to different systems will be much lower, since you know you can get your system back the way you want it easily.

