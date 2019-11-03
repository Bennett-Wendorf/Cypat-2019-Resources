param(
    #File containing all users and administrators that are supposed to exist on the target computer
    [Parameter(Mandatory=$true, Position=0)]
    [string]$pathToUsersFile,

    #Default password to change bad passwords to
    [Parameter(Mandatory=$true)]
    [Security.SecureString]$defaultPassword
)

#Import CSV database
$file = Import-Csv -Path $pathToUsersFile

#Searches through csv and looks for bad passwords.
ForEach($row in $file){
    $currentPassword = $row.AdminPasswords
    if($currentPassword.Length -lt 8){
        "$($row.Admins)'s password is less than 8 characters long."
        $badPass = $true
    }
    if($currentPassword -notmatch '!|@|#|%|^|&|$'){
        "$($row.Admins)'s password does not contain at least one special character."
        $badPass = $true
    }
    if($currentPassword -notmatch '\d'){
        "$($row.Admins)'s password does not contain at least one digit [0-9]."
        $badPass = $true
    }
    if(-not ($currentPassword -cmatch '[A-Z]')){
        "$($row.Admins)'s password does not contain at least one upper case letter [A-Z]."
        $badPass = $true
    }
    if(-not ($currentPassword -cmatch '[a-z]')){
        "$($row.Admins)'s password does not contain at least one lower case letter [a-z]."
        $badPass = $true
    }

    #User is alerted and asked if they want to change a bad password.
    if($badPass){
        "Would you like to change $($row.Admins)'s bad password? (y/n)"
        While($true) {
            $answer = Read-Host -Prompt 'Please input y or n'
            If($answer -eq "y"){
                $localUser = Get-LocalUser -Name $row.Admins
                Set-LocalUser $localUser -Password $defaultPassword
                break
            }
            ElseIf($answer -eq "n") {
                "Ok"
                break
            }
        }
    }
}