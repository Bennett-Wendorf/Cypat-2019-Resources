param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$userAccountsFile,

    #Default password to change bad passwords to
    [Parameter(Mandatory=$true, Position=1)]
    [Security.SecureString]$defaultPassword,

    #Determines if scripts will output extra debug information.
    [Parameter(Position=2)]
    [switch]$enableAdvancedDebugMode
)

if($enableAdvancedDebugMode){
    ""
    Write-Host "Advanced Debug Mode is now enabled."
}
""

#Call CheckAccounts.ps1 with parameter input
$ScriptPath = $PSScriptRoot + "\AllWindowsBuilds"
& "$($ScriptPath)\CheckAccounts.ps1" $userAccountsFile $enableAdvancedDebugMode

#Call CheckPassword.ps1 with parameter input
$ScriptPath = $PSScriptRoot + "\AllWindowsBuilds"
& "$($ScriptPath)\CheckPassword.ps1" $userAccountsFile $defaultPassword $enableAdvancedDebugMode