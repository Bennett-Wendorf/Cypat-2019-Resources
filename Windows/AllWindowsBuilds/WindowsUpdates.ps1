param(
    #Determines if this script will output extra information.
    [boolean]$enableAdvancedDebugMode = $false
)

if($enableAdvancedDebugMode){
    Write-Host "WindowsUpdates.ps1 has started with Advanced Debug Mode enabled."
}
Write-Host ""

if($enableAdvancedDebugMode){
    Write-Host "Installing PSWindowsUpdate powershell module."
}
Install-Module PSWindowsUpdate -Force

if($enableAdvancedDebugMode){
    Write-Host "Starting windows updates and accepting all. Not rebooting."
    Get-WUInstall -MicrosoftUpdate -AcceptAll -IgnoreReboot
}
else{
    $null = Get-WUInstall -MicrosoftUpdate -AcceptAll -IgnoreReboot
}

Write-Host "Would you like to reboot the computer? (y/n)"
    While($true) {
        $rebootResponse = Read-Host -Prompt 'Please input y or n'
        If($rebootResponse -eq "y"){
            if($enableAdvancedDebugMode){
                Write-Host "Rebooting the computer."
            }
            Restart-Computer
            break
        }
        ElseIf($rebootResponse -eq "n") {
            if($enableAdvancedDebugMode){
                Write-Host "Not rebooting computer due to user input."
            }
            else{
                Write-Host "Ok"
            }
            break
        }
    }