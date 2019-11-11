param(
    #Determines if this script will output extra information.
    [boolean]$enableAdvancedDebugMode = $false
)

if($enableAdvancedDebugMode){
    Write-Host "WindowsUpdates.ps1 has started with Advanced Debug Mode enabled."
}
""

Install-Module PSWindowsUpdate -Force

if($enableAdvancedDebugMode){
    Get-WUInstall -MicrosoftUpdate -AcceptAll -IgnoreReboot
}
else{
    $null = Get-WUInstall -MicrosoftUpdate -AcceptAll -IgnoreReboot
}