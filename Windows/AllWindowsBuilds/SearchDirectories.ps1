param(
    #File containing all users and administrators that should exist on the target computer
    [Parameter(Mandatory=$true)]
    [string]$pathToUsersFile,

    #Determines if this script will output extra information.
    [Parameter(Mandatory=$true)]
    [boolean]$enableAdvancedDebugMode = $false
)

if($enableAdvancedDebugMode){
    Write-Host "SearchDirectories.ps1 has started with Advanced Debug Mode enabled."
}
""

[String[]]$fileTypes = @("*.txt", "*.mp3", "*.mp4")
[String[]]$directories = @("Music", "Desktop", "Documents", "Downloads", "Pictures", "Videos")
[String[]]$excludes = @("My Music", "My Videos", "My Pictures")

$file = Import-Csv -Path $pathToUsersFile
if($enableAdvancedDebugMode -and $null -ne $file){
    Write-Host "CSV imported successfully."
}

Function SearchUser{
    param($user)
    if($user.Length -gt 0){
        if($enableAdvancedDebugMode){
            Write-Host "Searching $user's directories."
        }

        ForEach($directory in $directories){
            Get-ChildItem -Path "C:\Users\$user\$directory" -Recurse -Force -Include $fileTypes -Exclude $excludes -ErrorAction SilentlyContinue
        }
    }
}

ForEach($user in $file.Users){
    SearchUser $user
}
ForEach($admin in $file.Admins){
    SearchUser $admin
}