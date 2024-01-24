Import-Module activedirectory

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
 Foreach ($o in $OUs) {
    New-ADOrganizationalUnit -Name $o -Verbose
}
 
# Create Groups
Foreach ($g in $Groups) {
    New-ADGroup -Name $g `
    -Path "OU=Gruppen,DC=gr2,DC=laba304,DC=local" `
    -GroupScope Universal -GroupCategory Security -Verbose
} 
 

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

foreach ($l in $Leiter) {
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

foreach ($v in $Verbraucherberatung) {
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

foreach ($s in $Steuerberatung) {
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


$InternetcaffeeUser  =   'B.Mueller','B.Schneider','B.Lehmann','B.Hofmann'
$SteuerberatungUser =   'B.Krause','B.Hofmann','B.Mayer'
$VerbraucherberatungUser = 'B.Hofmann','B.Schulze','B.Wolf','B.Merkel'
$LeiterUser = 'B.Hofmann'
$TechnikUser = 'B.Lehmann', 'B.Hofmann'

Foreach ($i in $InternetcaffeeUser) {
    Add-ADGroupMember -Identity "Internetcaffee" -Members $i
}

Foreach ($s in $SteuerberatungUser) {
    Add-ADGroupMember -Identity "Steuerberatung" -Members $s
}

Foreach ($v in $VerbraucherberatungUser) {
    Add-ADGroupMember -Identity "Verbraucherberatung" -Members $v
}

Foreach ($l in $LeiterUser) {
    Add-ADGroupMember -Identity "Leiter" -Members $l
}

Foreach ($t in $TechnikUser) {
    Add-ADGroupMember -Identity "Technik" -Members $t
}


# Definieren der Gruppennamen
$Gruppen = 'Internetcaffee', 'Steuerberatung', 'Verbraucherberatung', 'Leiter', 'Technik'

# Variable die den Pfad zu den neuen Ordnern definiert
$FolderPath= "C:\Freigaben"
 
# Check ob der Ordner bereits existiert und erstellen des Ordners anhand des Gruppennamens mit Vorlagen
foreach ($g in $Gruppen){
  If(!(Test-Path -Path $FolderPath\$g-Vorlagen))
{
    #powershell create directory
    New-Item -ItemType Directory -Path $FolderPath\$g-Vorlagen
    Write-Host "New folder created successfully!" -f Green
}
Else
{
  Write-Host "Folder already exists!" -f Yellow
}
  
}

# Check ob der Ordner bereits existiert und erstellen des Ordners anhand des Gruppennamens mit Tausch
foreach ($g in $Gruppen){
  If(!(Test-Path -Path $FolderPath\$g-Tausch))
{
    #powershell create directory
    New-Item -ItemType Directory -Path $FolderPath\$g-Tausch
    Write-Host "New folder created successfully!" -f Green
}
Else
{
  Write-Host "Folder already exists!" -f Yellow
}
  
}

foreach ($g in $Gruppen){
  New-SmbShare -Name $g-Daten -Path $FolderPath\$g -FullAccess $g
  New-SmbShare -Name $g-Transfer -Path $FolderPath\$g -FullAccess $g
}

# Setzen des ShareQuotas
# Set-FsrmQuota -Path "C:\Freigaben\*" -Description "limit usage to 1.5 GB" -Size 1GB


# Importieren der GPO zur Automation:)
Import-GPO -BackupGPOName ShareMapping -TargetName ShareMapping -path -CreateIfNeeded .\GPOs 

