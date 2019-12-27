# -------------------------------------------------------------------------
# Configure network settings
# -------------------------------------------------------------------------
$ip = "192.168.100.10"
New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress $ip -PrefixLength 24 -DefaultGateway $ip
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses $ip, "192.168.100.20"   

# -------------------------------------------------------------------------
# Install Forest (Perform on Server Core)
# -------------------------------------------------------------------------
$domainname = "piet.periode1"
$netbios = "PIET"
$password = "P@ss123" | ConvertTo-SecureString -AsPlainText -Force
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools 
Install-ADDSForest -DomainName $domainname -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "7" -DomainNetbiosName $netbios -ForestMode "7" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$True -SysvolPath "C:\Windows\SYSVOL" -SafeModeAdministratorPassword:($password) -Force:$true 
$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
Set-ItemProperty $RunOnceKey "NextRun" "C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -ExecutionPolicy Unrestricted -File Z:\Step3.ps1"
Restart-computer

