Import-Module ActiveDirectory

$password = Read-Host "Enter default password for new users" -AsSecureString
$DomainDN = (Get-ADDomain).DistinguishedName
$UPNDomain = Read-Host "Enter your UPN domain"

# Map departments to their specific OU and Global Group
$DeptMap = @{
    "Domain-Admins" = @{
        OU    = "OU=Domain-Admins,OU=00-Admin,$DomainDN"
        Group = "GG_Domain_Admins"
    }
    "Server-Admins" = @{
        OU    = "OU=Server-Admins,OU=00-Admin,$DomainDN"
        Group = "GG_Server_Admins"
    }
    "IT-Helpdesk"   = @{
        OU    = "OU=IT-Helpdesk,OU=00-Admin,$DomainDN"
        Group = "GG_IT_Helpdesk"
    }
    "Finance"       = @{
        OU    = "OU=Finance,OU=Users,OU=01-Corp,$DomainDN"
        Group = "GG_Finance"
    }
    "HR"            = @{
        OU    = "OU=HR,OU=Users,OU=01-Corp,$DomainDN"
        Group = "GG_HR"
    }
    "Sales"         = @{
        OU    = "OU=Sales,OU=Users,OU=01-Corp,$DomainDN"
        Group = "GG_Sales"
    }
}

# Import the list of users
$UserList = Import-Csv -Path ".\users.csv"

foreach ($u in $UserList) {
    $first        = $u.FirstName.Trim()
    $last         = $u.LastName.Trim()
    $dept         = $u.Department.Trim()
    $firstInitial = $first.Substring(0,1).ToLower()
    $username     = "$($firstInitial)$($last.ToLower())"
    $displayName  = "$first $last"
    $upn          = "$username@$UPNDomain"

    if (-not $DeptMap.ContainsKey($dept)) {
        Write-Warning "Department '$dept' for user $username not recognized in map. Skipping."
        continue
    }

    $targetOU   = $DeptMap[$dept].OU
    $targetGroup = $DeptMap[$dept].Group

    # Create the AD User Object if existing logon name is not found
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$username'" -ErrorAction SilentlyContinue)) {
        New-ADUser -SamAccountName $username `
                   -UserPrincipalName $upn `
                   -Name $displayName `
                   -DisplayName $displayName `
                   -GivenName $first `
                   -Surname $last `
                   -Path $targetOU `
                   -AccountPassword $password `
                   -Enabled $true `
                   -ChangePasswordAtLogon $true `
                   -Department $dept

        Write-Host "Succesfully created and added User $username ($displayName) in $targetOU" -ForegroundColor Green
    } else {
        Write-Host "Failed to create User $username as it already exists" -ForegroundColor Red
    }

    # Add the user to the Global Group
    try {
        Add-ADGroupMember -Identity $targetGroup -Members $username -ErrorAction Stop
        Write-Host "Succesfully added $username to $targetGroup" -ForegroundColor Cyan
    } catch {
        Write-Warning "Could not add $username to ${targetGroup}: $($_.Exception.Message)"
    }
}
