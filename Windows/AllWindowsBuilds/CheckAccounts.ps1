param(
    #File containing all users and administrators that should exist on the target computer
    [string]$pathToUsersFile,

    #Determines if this script will output extra information.
    [Parameter(Mandatory=$true)]
    [boolean]$enableAdvancedDebugMode = $false
)

if($enableAdvancedDebugMode){
    Write-Host "CheckAccounts.ps1 has started with Advanced Debug Mode enabled."
}
""

#List to store users who have administrator permissions that they shouldn't.
$elevatedPermissionsUsers = New-Object System.Collections.Generic.List[String]

#List to store unauthorized users.
$unauthorizedUsers = New-Object System.Collections.Generic.List[String]

#Asks the user if they would like to demote elevated accounts and changes group membership accordingly
Function CheckAndRemoveElevatedUsers{
    If(!($elevatedPermissionsUsers.count -eq 0)){
        "elevatedPermissionsUsers are:"
        $elevatedPermissionsUsers
        ""
        "Would you like to downgrade the permissions of these users? (y/n)"
        While($true) {
            $answer = Read-Host -Prompt 'Please input y or n'
            If($answer -eq "y"){
                ForEach($user in $elevatedPermissionsUsers){
                    if($enableAdvancedDebugMode){
                        Write-Host "Demoted $($user)."
                    }
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

#Asks the user if they would like to remove unauthorized accounts
Function CheckAndRemoveUnauthorizedUsers{
    If(!($unauthorizedUsers.count -eq 0)){
        "Unauthorized users are:"
        $unauthorizedUsers
        ""
        "Would you like to delete of these users? (y/n)"
        While($true) {
            $answer = Read-Host -Prompt 'Please input y or n'
            If($answer -eq "y"){
                ForEach($user in $unauthorizedUsers){
                    if($enableAdvancedDebugMode){
                        Write-Host "Removed $($user)."
                    }
                    Remove-LocalUser -Name $user
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
            if($enableAdvancedDebugMode){
                Write-Host "$($currentLocalAdmin) was found in the csv." 
            }
        }
        Else{
            if($enableAdvancedDebugMode){
                Write-Host "$($currentLocalAdmin) was NOT found in the csv."
                Write-Host "$($currentLocalAdmin) added to elevatedPermissionsUsers"
            }
            $elevatedPermissionsUsers.Add($currentLocalAdmin)
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
            if($enableAdvancedDebugMode){
                Write-Host "$($currentLocalUser) was found in the csv." 
            }
        }
        Else{
            if($enableAdvancedDebugMode){
                Write-Host "$($currentLocalUser) was NOT found in the csv."
                Write-Host "$($currentLocalUser) added to unauthorizedUsers."
            }
            $unauthorizedUsers.Add($currentLocalUser)
        }
    }

}

#Import CSV database
$file = Import-Csv -Path $pathToUsersFile
if($enableAdvancedDebugMode -and $null -ne $file){
    Write-Host "CSV imported successfully."
}

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

#Prints group memberships if advanced debug mode is enabled
if($enableAdvancedDebugMode){
    "localAdmins are:"
    $localAdmins
    ""
    "localUsers are:"
    $localUsers
    ""
}

#Remove built in accounts from check list and assigns the output to $null to suppress boolean output
if($enableAdvancedDebugMode){
    Write-Host "Ignoring DefaultAccount: " + $localUsers.Remove("DefaultAccount")
    Write-Host "Ignoring Guest: " + $localUsers.Remove("Guest")
    Write-Host "Ignoring Administrator: " + $localAdmins.Remove("Administrator")
    Write-Host "Ignoring WDAGUtilityAccount: " + $localUsers.Remove("WDAGUtilityAccount")
}
else{
    $null = $localUsers.Remove("DefaultAccount")
    $null = $localUsers.Remove("Guest")
    $null = $localAdmins.Remove("Administrator")
    $null = $localUsers.Remove("WDAGUtilityAccount")
}


if($enableAdvancedDebugMode){
    "Local Admins:"
}
CheckLocalAdminsVsCsv
if($enableAdvancedDebugMode){
    ""
    "Local Users:"
}
CheckLocalUsersVsCsv
if($enableAdvancedDebugMode){
    ""
}
CheckAndRemoveElevatedUsers
if($enableAdvancedDebugMode){
    ""
}
CheckAndRemoveUnauthorizedUsers
""