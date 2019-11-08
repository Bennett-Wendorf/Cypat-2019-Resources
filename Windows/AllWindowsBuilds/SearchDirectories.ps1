param(
    #File containing all users and administrators that should exist on the target computer
    [string]$pathToUsersFile,

    #Determines if this script will output extra information.
    [Parameter(Mandatory=$true)]
    [boolean]$enableAdvancedDebugMode = $false
)

if($enableAdvancedDebugMode){
    Write-Host "SearchDirectories.ps1 has started with Advanced Debug Mode enabled."
}
""

$fileTypes = "txt", "mp3", "mp4"
$directories = "Music", "Desktop", "Documents", "Downloads", "Pictures", "Videos"

$file = Import-Csv -Path $pathToUsersFile

Function SearchUser{
    param($user)
    if($enableAdvancedDebugMode){
        Write-Host "Searching $user's directories."
    }

    ForEach($directory in $directories){
        ForEach($fileType in $fileTypes){
            Get-ChildItem -Path "C:\Users\$user\$directory" -Recurse -Force -Include "*.$fileType"
        }
    }
}

ForEach($user in $file.Users){
    SearchUser $user
}
ForEach($admin in $file.Admins){
    SearchUser $admin
}