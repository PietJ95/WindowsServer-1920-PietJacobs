# -------------------------------------------------------------------------
# Install Domain Controller (Perform on Server Core)
# -------------------------------------------------------------------------
$domainname = "piet.periode1"
$password = "P@ss123" | ConvertTo-SecureString -AsPlainText -Force
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools 
Install-ADDSDomainController -DomainName $domainname -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$True -SysvolPath "C:\Windows\SYSVOL" -SafeModeAdministratorPassword:($password) -Force:$true 
$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
Set-ItemProperty $RunOnceKey "NextRun" "C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -ExecutionPolicy Unrestricted -File Z:\Step4.ps1"
Restart-computer
