#Script by Gruppe 2

# Importieren des notwendigen Moduls
Import-Module activedirectory

# Sicherstellen, dass es keine Probleme mit der Execution Policiy gibt
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force -Confirm:$false

# Definieren der Gruppenzuweisungen
$Internetcaffee  =   'B.Mueller','B.Schneider','B.Lehmann','B.Hofmann'
$Steuerberatung =   'B.Krause','B.Hofmann','B.Mayer'
$Verbraucherberatung = 'B.Hofmann','B.Schulze','B.Wolf','B.Merkel'
$Leiter = 'B.Hofmann'
$Technik = 'B.Lehmann', 'B.Hofmann'

Foreach ($i in $Internetcaffee) {
    Add-ADGroupMember -Identity "Internetcaffee" -Members $i
}

Foreach ($s in $Steuerberatung) {
    Add-ADGroupMember -Identity "Steuerberatung" -Members $s
}

Foreach ($v in $Verbraucherberatung) {
    Add-ADGroupMember -Identity "Verbraucherberatung" -Members $v
}

Foreach ($l in $Leiter) {
    Add-ADGroupMember -Identity "Leiter" -Members $l
}

Foreach ($t in $Technik) {
    Add-ADGroupMember -Identity "Technik" -Members $t
}