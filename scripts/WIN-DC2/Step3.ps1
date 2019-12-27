# -------------------------------------------------------------------------
# Configure DNS
# -------------------------------------------------------------------------
$Forwarder = "8.8.8.8"
Add-DnsServerForwarder -IPAddress $Forwarder -PassThru

# -------------------------------------------------------------------------
# Install DHCP
# -------------------------------------------------------------------------
Install-WindowsFeature -Name 'DHCP' -IncludeManagementTools;

# -------------------------------------------------------------------------
# Set hostname
# -------------------------------------------------------------------------
$hostname = "WIN-DC2"
Rename-Computer -ComputerName $env:COMPUTERNAME -newName $hostname -Force
Restart-Computer
