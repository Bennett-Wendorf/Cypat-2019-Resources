param(
    [string]$usersFile
)

$file = Import-Csv -Path $usersFile

$localUsers = New-Object System.Collections.Generic.List[String]
foreach($user in Get-localUser){
    $localUsers.Add($user.Name)
}

$localAdmins = Get-LocalGroupMember -Group "Administrators"

Function CheckLocalAdminsVsCsv{
    ForEach($currentLocalAdmin in $localAdmins) {
        :ToNextLocalUser_LABEL
        ForEach($admin in $file.Admins){
            $currentLocalAdminName = $currentLocalAdmin.Name.substring($env:COMPUTERNAME.Length+1)
            If($currentLocalAdminName -eq $admin){
                $localAdminMatch = 1
                break :ToNextLocalUser_LABEL
            }
            Else{
                $localAdminMatch = 0
            }
        }

        
        If($localAdminMatch){
            Write-Host "$($currentLocalAdminName) was found in the csv." 
        }
        Else{
            Write-Host "$($currentLocalAdminName) was NOT found in the csv."
        }
    }
}

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
CheckLocalAdminsVsCsv
