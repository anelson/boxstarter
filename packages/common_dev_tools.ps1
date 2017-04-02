# Install dev tools that are needed for a variety of programming tasks, not specific to one
# language or project
choco install git.install -params '"/GitAndUnixToolsOnPath /NoAutoCrlf"' --limitoutput
choco install gitkraken                 --limitoutput
choco pin add -n=gitkraken  #auto-updates take priority over chocolatey published package updates
choco install nuget.commandline         --limitoutput
choco install windbg              --limitoutput
choco install vmwareworkstation                    --limitoutput
choco pin add -n=vmwareworkstation  #auto-updates take priority over chocolatey published package updates

choco install vim                    --limitoutput
choco install sublimetext3                    --limitoutput