# -----------------------------------
# Configure network settings
# -----------------------------------
$ip = "192.168.100.20"
$gw = "192.168.100.10"
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress $ip -PrefixLength 24 -DefaultGateway $gw
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $gw, $ip

# -----------------------------------
# Promote to Domain Controller
# -----------------------------------
$domainname = "piet.periode1"
$username = "PIET\Administrator"
$credpassword = ConvertTo-SecureString "adminPass123" -AsPlainText -Force
$password = "P@ss123" | ConvertTo-SecureString -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $credpassword
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools 
Install-ADDSDomainController -DomainName $domainname -Credential $credential -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$True -SysvolPath "C:\Windows\SYSVOL" -SafeModeAdministratorPassword:($password) -Force:$true 
$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
Set-ItemProperty $RunOnceKey "NextRun" "C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -ExecutionPolicy Unrestricted -File Z:\Step3.ps1"
Restart-computer
