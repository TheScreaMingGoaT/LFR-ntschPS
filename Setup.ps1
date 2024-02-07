Import-Module activedirectory

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force -Confirm:$false
 
# Define OUs, Groups and Users and Attributes here
$OUs            =   'Mitarbeiter','Gruppen'
$Groups         =   'Steuerberatung','Verbraucherberatung','Leiter','Technik' 
$Steuerberatung =   'Bjoern Krause','Bjoern Hofmann','Bjoern Mayer'
$Verbraucherberatung = 'Bjoern Hofmann','Bjoern Schulze','Bjoern Wolf','Bjoern Merkel'
$Leiter = 'Bjoern Hofmann'
$Technik = 'Bernd Lehmann', 'Bjoern Hofmann'
$Mitarbeiter = 'Bjoern Mueller','Bjoern Schneider','Bernd Lehmann','Bjoern Hoffmann','Bjoern Schulze','Bjoern Wolf','Bjoern Merkel','Bjoern Krause','Bjoern Mayer'

# User Password 
$userpw = Read-Host "Enter a password for the users"

foreach ($o in $OUs) {
    New-ADOrganizationalUnit -Name $o -Verbose
}
 
# Create Groups
foreach ($g in $Groups) {
    New-ADGroup -Name $g `
    -Path "OU=Gruppen,DC=gr2,DC=laba304,DC=local" `
    -GroupScope Universal -GroupCategory Security -Verbose
} 
 

foreach ($i in $Mitarbeiter) {
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

$InternetcaffeeGroup  =   'B.Mueller','B.Schneider','B.Lehmann','B.Hoffmann'
$SteuerberatungGroup =   'B.Krause','B.Hoffmann','B.Mayer'
$VerbraucherberatungGroup = 'B.Hoffmann','B.Schulze','B.Wolf','B.Merkel'
$LeiterGroup = 'B.Hoffmann'
$TechnikGroup = 'B.Lehmann', 'B.Hoffmann'






# Gruppenmitglieder einfügen und Netlogon Skripte verteilen
Foreach ($s in $SteuerberatungGroup) {
    Add-ADGroupMember -Identity "Steuerberatung" -Members $s
}

Foreach ($v in $VerbraucherberatungGroup) {
    Add-ADGroupMember -Identity "Verbraucherberatung" -Members $v
}

Foreach ($l in $LeiterGroup) {
    Add-ADGroupMember -Identity "Leiter" -Members $l
}

Foreach ($t in $TechnikGroup) {
    Add-ADGroupMember -Identity "Technik" -Members $t
}

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
  New-SmbShare -Name $g-Tausch -Path $FolderPath\$g-Tausch -FullAccess "gr2.laba304.local\$g"
  New-SmbShare -Name $g-Vorlagen -Path $FolderPath\$g-Vorlagen -ReadAccess "gr2.laba304.local\$g"
  New-FsrmQuota -Path "$FolderPath\$g-Tausch" -Description "limit usage to 1 GB." -Size 1GB
  New-FsrmQuota -Path "$FolderPath\$g-Vorlagen"  -Description "limit usage to 1 GB." -Size 1GB
}



$UserHome = 'B.Mueller','B.Schneider','B.Lehmann','B.Hoffmann','B.Mayer','B.Krause','B.Wolf','B.Merkel'

foreach($m in $UserHome){
    New-Item -Path "C:\Home\$m" -ItemType Directory
    New-SmbShare -Name $m -Path "C:\Home\$m" -FullAccess "gr2.laba304.local\$m"
    SET-ADUser $m -HomeDirectory "\\gr2-dc\$m" -HomeDrive H:

}



