#Script by Gruppe 2

# Importieren des notwendigen Moduls
# Import-Module activedirectory

# Sicherstellen, dass es keine Probleme mit der Execution Policiy gibt
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force -Confirm:$false

# Definieren der Gruppennamen
$Gruppen = 'Internetcaffee', 'Steuerberatung', 'Verbraucherberatung', 'Leiter', 'Technik'

# Variable die den Pfad zu den neuen Ordnern definiert
$FolderPath= "C:\Freigaben"
 
# Check ob der Ordner bereits existiert und erstellen des Ordners anhand des Gruppennamens
foreach ($g in $Gruppen){
  Write-Host "$FolderPath\$g"
}

<#If(!(Test-Path -Path $FolderPath))
{
    #powershell create directory
    New-Item -ItemType Directory -Path $FolderPath
    Write-Host "New folder created successfully!" -f Green
}
Else
{
  Write-Host "Folder already exists!" -f Yellow
}

#Read more: https://www.sharepointdiary.com/2021/07/create-a-folder-using-powershell.html#ixzz8LWHKXj1K #>
