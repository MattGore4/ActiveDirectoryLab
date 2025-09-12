#Variable holding the plaintext password for users
$PASSWORD_FOR_USERS   = "Password1"

#Variable holding an array of user first and last names
$USER_FIRST_LAST_LIST = Get-Content .\names.txt

#Convert the password into a secure string for AD
$password = ConvertTo-SecureString $PASSWORD_FOR_USERS -AsPlainText -Force

#Create a new OU called _USERS
New-ADOrganizationalUnit -Name _USERS -ProtectedFromAccidentalDeletion $false


#Loop through each user's name
foreach ($n in $USER_FIRST_LAST_LIST) {

#Split the name into first and last
    $first = $n.Split(" ")[0].ToLower()
    $last = $n.Split(" ")[1].ToLower()

#Combine the first letter of the first name with the last name and set it to lowercase
    $username = "$($first.Substring(0,1))$($last)".ToLower()

    Write-Host "Creating user: $($username)" -BackgroundColor Black -ForegroundColor Cyan


#Create the AD User
    New-AdUser -AccountPassword $password `
               -GivenName $first `
               -Surname $last `
               -DisplayName $username `
               -Name $username `
               -EmployeeID $username `
               -PasswordNeverExpires $true `
               -Path "ou=_USERS,$(([ADSI]`"").distinguishedName)" `
               -Enabled $true
}
