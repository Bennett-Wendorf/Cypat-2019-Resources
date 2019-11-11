param(
    #Determines if this script will output extra information.
    [boolean]$enableAdvancedDebugMode = $false
)

if($enableAdvancedDebugMode){
    Write-Host "WindowsDefender.ps1 has started with Advanced Debug Mode enabled."
}
""

if($enableAdvancedDebugMode){
    Write-Host "Current Windows defender status: "
    Get-MpComputerStatus
}

if($enableAdvancedDebugMode){
    Write-Host "Updating malware definitions."
    Update-MpSignature
}
else{
    $null = Update-MpSignature
}

if($enableAdvancedDebugMode){
    Write-Host "Enabling Realtime Monitoring."
}
Set-MpPreference -DisableRealtimeMonitoring $false

if($enableAdvancedDebugMode){
    Write-Host "Starting scan."
}
if($enableAdvancedDebugMode){
    Start-MpScan
}
else {
    $null = Start-MpScan
}