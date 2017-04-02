# Install standard apps always needed on a Windows system

# Browsers
choco install googlechrome              --limitoutput
choco pin add -n=googlechrome  #auto-updates take priority over chocolatey published package updates

choco install firefox              --limitoutput
choco pin add -n=firefox  #auto-updates take priority over chocolatey published package updates

# Make Chrome default (this seems not to be working on Windows 10)
$chromePath = "${Env:ProgramFiles(x86)}\Google\Chrome\Application\" 
$chromeApp = "chrome.exe"
$chromeCommandArgs = "--make-default-browser"
& "$chromePath$chromeApp" $chromeCommandArgs

choco install silverlight --limitoutput

# Chat
choco install skype                     --limitoutput
choco pin add -n=skype  #auto-updates take priority over chocolatey published package updates

choco install slack                    --limitoutput
choco pin add -n=slack  #auto-updates take priority over chocolatey published package updates

# Utilities
choco install 7zip.install              --limitoutput
choco install f.lux --limitoutput
choco install putty --limitoutput
choco install filezilla --limitoutput
choco install rdcman                    --limitoutput
choco install fiddler4                  --limitoutput
choco install winscp                    --limitoutput
choco install nmap                      --limitoutput
choco install sysinternals              --limitoutput
choco install windirstat              --limitoutput
choco install commandwindowhere         --limitoutput

# Apps
choco install office365proplus              --limitoutput
choco install evernote --limitoutput
choco pin add -n=evernote  #auto-updates take priority over chocolatey published package updates

choco install conemu              --limitoutput
choco install ethanbrown.conemuconfig              --limitoutput


# As of 21 Nov 2016, the dropbox package is broken
# choco install dropbox               --limitoutput

# As of 1 April 2017, the 1password package is still the ancient 4.x version, not 6.x
# choco install 1password              --limitoutput
