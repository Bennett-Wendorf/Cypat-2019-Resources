param(
    [Parameter(Mandatory=$true)]
    [string]$relativePathToUserAccountsFile
)
$ScriptPath = $PSScriptRoot + "\AllWindowsBuilds"
& "$ScriptPath\CheckAccounts.ps1" $relativePathToUserAccountsFile