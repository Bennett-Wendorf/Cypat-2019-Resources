param(
    #File containing all users and administrators that should exist on the target computer
    [Parameter(Mandatory=$true)]
    [string]$userAccountsFile,

    #Default password to change bad passwords to
    [Parameter(Mandatory=$true)]
    [Security.SecureString]$defaultPassword,

    #Determines if scripts will output extra debug information.
    [switch]$enableAdvancedDebugMode
)

#Notifies the user if Advanced Debug Mode is enabled.
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