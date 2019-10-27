param(
    [string]$usersFile
)

$file = Import-Csv -Path $usersFile
$localUsers = Get-localUser

Function CheckLocalUsersVsCsv{
    ForEach($currentLocalUser in $localUsers) {
        :ToNextLocalUser_LABEL
        ForEach($user in $file.Users){
            If($currentLocalUser.Name -eq $user){
                $localUserMatch = 1
                break :ToNextLocalUser_LABEL
            }
            Else{
                $localUserMatch = 0
            }
        }

        
        If($localUserMatch){
            Write-Host "$($currentLocalUser) was found in the csv." 
        }
        Else{
            Write-Host "$($currentLocalUser) was NOT found in the csv."
        }
    }

}

CheckLocalUsersVsCsv
