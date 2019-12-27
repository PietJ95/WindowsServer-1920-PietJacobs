# -------------------------------------------------------------------------
# Configure network settings
# -------------------------------------------------------------------------
$ip = "192.168.100.30"
$gw = "192.168.100.10"
$dns = "192.168.100.10"
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress $ip -PrefixLength 24 -DefaultGateway $gw
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $gw, $dns

# Set NextRun script
Set-ItemProperty $RunOnceKey "NextRun" "C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -ExecutionPolicy Unrestricted -File C:\scripts\Step2.ps1"

# -------------------------------------------------------------------------
# Set hostname
# -------------------------------------------------------------------------
$hostname = "WIN-SQL-SCCM"
Rename-Computer -ComputerName $env:COMPUTERNAME -newName $hostname -Force
Restart-Computer