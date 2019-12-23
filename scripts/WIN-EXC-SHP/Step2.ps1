# -------------------------------------------------------------------------
# Change networksettings
# -------------------------------------------------------------------------
$ip = "192.168.100.40" 
$dns = "192.168.100.10"
$gw = "192.168.100.10"
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress $ip -PrefixLength 24 -DefaultGateway $gw
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $gw, $dns

# -------------------------------------------------------------------------
# Join existing Domain
# -------------------------------------------------------------------------
$domainname = "piet.periode1"
$username = "$domainname\Administrator"
$password = "P@ss123" | ConvertTo-SecureString -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username, $password)
Add-Computer -DomainName $domainname -Credential $credential
Set-ItemProperty $RunOnceKey "NextRun" "C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -ExecutionPolicy Unrestricted -File C:\scripts\Step3.ps1"
Restart-computer
