	
param([Parameter(Mandatory=$true)][String]$samAccountName)
 
$fullPath = "\\gr2-dc\Home\{0}" -f $samAccountName
$driveLetter = "Z:"
 
$User = Get-ADUser -Identity $samAccountName
 
if($User -ne $Null) {
    Set-ADUser $User -HomeDrive $driveLetter -HomeDirectory $fullPath -ea Stop
    $homeShare = New-Item -path $fullPath -ItemType Directory -force -ea Stop
 
    $acl = Get-Acl $homeShare
 
    $FileSystemRights = [System.Security.AccessControl.FileSystemRights]"Modify"
    $AccessControlType = [System.Security.AccessControl.AccessControlType]::Allow
    $InheritanceFlags = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit"
    $PropagationFlags = [System.Security.AccessControl.PropagationFlags]"InheritOnly"
 
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule ($User.SID, $FileSystemRights, $InheritanceFlags, $PropagationFlags, $AccessControlType)
    $acl.AddAccessRule($AccessRule)
 
    Set-Acl -Path $homeShare -AclObject $acl -ea Stop
 
    Write-Host ("HomeDirectory created at {0}" -f $fullPath)
}