$username = Read-Host 

New-Item -Path "C:\Home\$username" -ItemType Directory
New-SmbShare -Name $username -Path "C:\Home\$username" -ChangeAccess "gr2.laba304.local\$username"
SET-ADUser $username -HomeDirectory "\\gr2-dc\$username" -HomeDrive H: