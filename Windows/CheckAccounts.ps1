param(
    #File containing all users and administrators that should exist on the target computer
    [string]$usersFile
)

$elevatedPermissionsUsers = New-Object System.Collections.Generic.List[String]

#Asks the user if they would like to demote elevated accounts and changes group membership accordingly
Function CheckAndRemoveElevatedUsers{
    If(!($elevatedPermissionsUsers.count -eq 0)){
        "Would you like to downgrade the permissions of these users? (y/n)"
        While($true) {
            $answer = Read-Host -Prompt 'Please input y or n: '
            If($answer -eq "y"){
                ForEach($user in $elevatedPermissionsUsers){
                    Remove-LocalGroupMember Administrators $user
                }
                break
            }
            ElseIf($answer -eq "n") {
                "Ok"
                break
            }
        } 
    }
}

#Checks $localAdmin against the Admins column of the csv file
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
            $elevatedPermissionsUsers.Add($currentLocalAdmin)
            Write-Host "$($currentLocalAdmin) added to elevatedPermissionsUsers"
        }
    }
}

#Checks $localUsers against the Users column of the csv file
Function CheckLocalUsersVsCsv{
    ForEach($currentLocalUser in $localUsers) {
        :ToNextLocalUser_LABEL
        ForEach($user in $file.Users){
            If($currentLocalUser -eq $user){
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

#Create new list to store local administrators
$localAdmins = New-Object System.Collections.Generic.List[String]

#Gets users of the Administrators group
$localAdminsTemp = Get-LocalGroupMember -Group "Administrators"

#Adds names of all administrators to $localAdmins
foreach($admin in $localAdminsTemp){
    $localAdmins.Add($admin.Name.substring($env:COMPUTERNAME.Length+1))
}

#Create new list to store local user accounts
$localUsers = New-Object System.Collections.Generic.List[String]

#Adds names of all non-administrator users to $localUsers
foreach($user in Get-localUser){
    $isAdmin = $false;
    foreach($admin in $localAdmins){
        if($admin -eq $user){
            $isAdmin = $true
        }
    }
    if(-Not $isAdmin)
    {
        $localUsers.Add($user.Name)   
    }     
}
"localAdmins are:"
$localAdmins
""
"localUsers are:"
$localUsers
""

#Remove built in accounts from check list and assigns the output to $null to suppress boolean output
$null = $localUsers.Remove("DefaultAccount")
$null = $localUsers.Remove("Guest")
$null = $localAdmins.Remove("Administrator")

"Local Admins:"
CheckLocalAdminsVsCsv
""
"Local Users:"
CheckLocalUsersVsCsv
""
"elevatedPermissionsUsers are:"
$elevatedPermissionsUsers
CheckAndRemoveElevatedUsers