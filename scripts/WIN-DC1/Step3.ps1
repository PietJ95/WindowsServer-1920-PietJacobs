# -------------------------------------------------------------------------
# Configure DNS
# -------------------------------------------------------------------------
$Forwarder = "8.8.8.8"
Add-DnsServerForwarder -IPAddress $Forwarder -PassThru

# -------------------------------------------------------------------------
# Configure DHCP
# -------------------------------------------------------------------------
$ip = "192.168.100.10"
$startScope = "192.168.100.100"
$endScope = "192.168.100.250"
Install-WindowsFeature -Name 'DHCP' -IncludeManagementTools 
Add-DhcpServerV4Scope -Name "DHCP Scope" -StartRange $startScope -EndRange $endScope -SubnetMask 255.255.255.0 
Set-DhcpServerV4OptionValue -DnsServer $ip -Router $ip 
Set-DhcpServerv4Scope -ScopeId $ip -LeaseDuration 1.00:00:00 
Restart-Service DHCPServer -Force  
#Authorize the DHCP server for our domain
Add-DhcpServerInDC -DnsName WIN-DC1.piet.periode1
# -------------------------------------------------------------------------
# Install RRAS
# -------------------------------------------------------------------------

Install-WindowsFeature Routing -IncludeManagementTools
$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
Set-ItemProperty $RunOnceKey "NextRun" "C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -ExecutionPolicy Unrestricted -File C:\scripts\Step4.ps1"
Restart-Computer
