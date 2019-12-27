# -----------------------------------
# Configure DNS
# -----------------------------------
$Forwarder = "8.8.8.8"
Add-DnsServerForwarder -IPAddress $Forwarder -PassThru

# -----------------------------------
# Install DHCP
# -----------------------------------
Install-WindowsFeature -Name 'DHCP' -IncludeManagementTools;

