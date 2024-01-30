#Script by Gruppe 2

# Importieren des notwendigen Moduls
# Import-Module activedirectory

# Sicherstellen, dass es keine Probleme mit der Execution Policiy gibt
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force -Confirm:$false

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
  New-SmbShare -Name $g-Tausch -Path $FolderPath\$g-Tausch 
  New-SmbShare -Name $g-Vorlagen -Path $FolderPath\$g-Vorlagen 
}

foreach($g in $Gruppen){
    Grant-SmbShareAccess -Name $g-Tausch -AccountName $g -AccessRight Full
    Grant-SmbShareAccess -Name $g-Vorlagen -AccountName $g -AccessRight Full
}



# Erstellen des Userhome Ordners

$user = New-Object -TypeName 'System.Security.Principal.SecurityIdentifier' -ArgumentList @([System.Security.Principal.WellKnownSidType]::AuthenticatedUserSid, $null)
$path = 'C:\Home'
$acl  = Get-Acl -Path $path
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule($user, 'FullControl','Allow')
$acl.SetAccessRule($rule)
Set-Acl -Path $path -AclObject $acl