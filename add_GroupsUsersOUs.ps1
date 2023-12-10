<# 
Author: Patrick Gruenauer | Microsoft PowerShell MVP [2018-2024]
Web: sid-500.com
This script is intended for use in a Test environment. It creates OUs, 
Groups and Users. 
#>
Import-Module activedirectory
# If necessary, bypass the execution policy.
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force -Confirm:$false
 
# Define OUs, Groups and Users and Attributes here
$OUs            =   'Mitarbeiter','Gruppen'
$Groups         =   'Internetcaffee','Steuerberatung','Technik','Leiter','Verbraucherberatung'
$Internetcaffe  =   'Bjoern Mueller','Bjoern Schneider','Bernd Lehmann','Bjoern Hoffmann'
$Steuerberatung =   'Bjoern Krause','Bjoern Hofmann','Bjoern Mayer'
$Verbraucherberatung = 'Bjoern Hofmann','Bjoern Schulze','Bjoern Wolf','Bjoern Merkel'
$Leiter = 'Bjoern Hofmann'
$Technik = 'Bernd Lehmann', 'Bjoern Hofmann'

 
# User Password 
$userpw = Read-Host "Enter a password for the users"
 
# Creating litte helpers ...
$root = $env:USERDNSDOMAIN.Split('.')[1]
$sub = $env:USERDNSDOMAIN.Split('.')[0]
 
# Create OUs
<# Foreach ($o in $OUs) {
    New-ADOrganizationalUnit -Name $o -Verbose
}#>
 
# Create Groups
<# Foreach ($g in $Groups) {
    New-ADGroup -Name $g `
    -Path "OU=Gruppen,DC=gr2,DC=laba304,DC=local" `
    -GroupScope Universal -GroupCategory Security -Verbose
} #>
 
# Create users and store them in the corresponding OU. 
# Add users to groups Leiter to the OU.
 foreach ($i in $Technik) {
    $split =    $i.split(' ')
    $sam =      ($split[0].Substring(0,1) + '.' + $split[1]).ToLower()
    $upn =      ($split[0].Substring(0,1) + '.' + $split[1] + '@' + 
                $env:USERDNSDOMAIN).ToLower()
    New-ADUser `
    -Name $i `
    -GivenName $split[0] `
    -Surname $split[1] `
    -DisplayName $i `
    -Enabled $true `
    -AccountPassword (ConvertTo-SecureString -AsPlainText $userpw -Force) `
    -SamAccountName $sam `
    -UserPrincipalName $upn `
    -Path "OU=Mitarbeiter,DC=gr2,DC=laba304,DC=local" `
    -EmailAddress $upn `
    -Verbose
}
 
<#
foreach ($t in $Technician) {
    $split =    $t.split(' ')
    $sam =      ($split[0].Substring(0,1) + '.' + $split[1]).ToLower()
    $upn =      ($split[0].Substring(0,1) + '.' + $split[1] + '@' + 
                $env:USERDNSDOMAIN).ToLower()
    New-ADUser `
    -Name $t `
    -GivenName $split[0] `
    -Surname $split[1] `
    -DisplayName $t `
    -Enabled $true `
    -AccountPassword (ConvertTo-SecureString -AsPlainText $userpw -Force) `
    -SamAccountName $sam `
    -UserPrincipalName $upn `
    -Path "OU=Technicians,DC=$sub,DC=$root" `
    -EmailAddress $upn `
    -Department 'Technicians' `
    -City (Get-Random -InputObject $City[0..3]) `
    -Verbose
}
 
foreach ($c in $CEO) {
    $split =    $c.split(' ')
    $sam =      ($split[0].Substring(0,1) + '.' + $split[1]).ToLower()
    $upn =      ($split[0].Substring(0,1) + '.' + $split[1] + '@' + 
                $env:USERDNSDOMAIN).ToLower()
    New-ADUser `
    -Name $c `
    -GivenName $split[0] `
    -Surname $split[1] `
    -DisplayName $c `
    -Enabled $true `
    -AccountPassword (ConvertTo-SecureString -AsPlainText $userpw -Force) `
    -SamAccountName $sam `
    -UserPrincipalName $upn `
    -Path "OU=CEOs,DC=$sub,DC=$root" `
    -EmailAddress $upn `
    -Department 'CEOs' `
    -City (Get-Random -InputObject $City[0..3]) `
    -Verbose
}
 
# Add OU Users to Group
$CEOg = "OU=CEOs,DC=$sub,DC=$root"
$hrg = "OU=HR,DC=$sub,DC=$root"
$techg = "OU=Technicians,DC=$sub,DC=$root"
$HRg = "OU=HR,DC=$sub,DC=$root"
 
Get-ADUser -Filter * -SearchBase $CEOg | 
ForEach-Object {Add-ADGroupMember -Identity CEOs -Members $_ -Verbose}
 
Get-ADUser -Filter * -SearchBase $hrg | 
ForEach-Object {Add-ADGroupMember -Identity HR -Members $_ -Verbose}
 
Get-ADUser -Filter * -SearchBase $techg | 
ForEach-Object {Add-ADGroupMember -Identity Technicians -Members $_ -Verbose}
 
Get-ADUser -Filter * -SearchBase $HRg | 
ForEach-Object {Add-ADGroupMember -Identity HR -Members $_ -Verbose}
 
Start-Process dsa.msc #>