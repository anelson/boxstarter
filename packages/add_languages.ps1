# Make sure the additional keyboards are configured

$langs = Get-WinUserLanguageList
if (-not ($langs -contains "ru-RU")) { $langs.Add("ru-RU") }
if (-not ($langs -contains "es-ES")) { $langs.Add("es-ES") }
Set-WinUserLanguageList $langs
