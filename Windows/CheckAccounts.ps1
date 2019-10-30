param(
    [string]$usersFile
)

#Checks $localAdmin against the Admins column of a csv file
Function CheckLocalAdminsVsCsv{
    ForEach($currentLocalAdmin in $localAdmins) {
        :ToNextLocalUser_LABEL
        ForEach($admin in $file.Admins){
            If($currentLocalAdmin -eq $admin){
                $localAdminMatch = 1
                break :ToNextLocalUser_LABEL
            }
            Else{
                $localAdminMatch = 0
            }
        }

        
        If($localAdminMatch){
            Write-Host "$($currentLocalAdmin) was found in the csv." 
        }
        Else{
            Write-Host "$($currentLocalAdmin) was NOT found in the csv."
        }
    }
}

#Checks $localUsers against the Users column of a csv file
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

#Import CSV database
$file = Import-Csv -Path $usersFile

$localAdmins = New-Object System.Collections.Generic.List[String]

#Gets users of the Administrators group
$localAdminsTemp = Get-LocalGroupMember -Group "Administrators"

#Adds names of all administrators to $localAdmins
foreach($admin in $localAdminsTemp){
    $localAdmins.Add($admin.Name.substring($env:COMPUTERNAME.Length+1))
}

$localUsers = New-Object System.Collections.Generic.List[String]

#Adds names of all non-administrator users to $localUsers
foreach($user in Get-localUser){
    #Need to not add users that are admins
    $localUsers.Add($user.Name)        
}
$localUsers
""

#Remove built in accounts from check list and assigns the output to $null to suppress boolean output
$null = $localUsers.Remove("DefaultAccount")
$null = $localUsers.Remove("Guest")
$null = $localAdmins.Remove("Administrator")

CheckLocalAdminsVsCsv
CheckLocalUsersVsCsv