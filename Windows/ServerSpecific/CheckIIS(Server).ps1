param(
    #Determines if this script will output extra information.
    [boolean]$enableAdvancedDebugMode = $false
)

$IISEnabled = $false
$IISFeatureName = "Web-Server"

if($enableAdvancedDebugMode){
    Write-Host "WindowsDefender.ps1 has started with Advanced Debug Mode enabled."
}
Write-Host ""

if($enableAdvancedDebugMode){
    Write-Host "Checking if IIS is installed"
}

if((Get-WindowsOptionalFeature -Online -FeatureName $IISFeatureName).State -eq "Enabled"){
    Write-Host "IIS is enabled."
    $IISEnabled = $true
}

if($IISEnabled){
    Write-Host "Would you like to remove IIS? (y/n)"
    While($true) {
        $answer = Read-Host -Prompt 'Please input y or n'
        If($answer -eq "y"){
            if($enableAdvancedDebugMode){
                Write-Host "Removing IIS."
            }
            Remove-WindowsFeature -Name $IISFeatureName
            break
        }
        ElseIf($answer -eq "n") {
            if($enableAdvancedDebugMode){
                Write-Host "Not removing IIS due to user input."
            }
            else{
                Write-Host "Ok"
            }
            break
        }
    }
}