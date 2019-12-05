# -------------------------------------------------------------------------
# Set hostname
# -------------------------------------------------------------------------
function setHostname {
    $hostname = "WS-GUI"
    Rename-Computer -ComputerName $env:COMPUTERNAME -newName $hostname -Force
    Restart-Computer
}
# -------------------------------------------------------------------------
# Configure network settings
# -------------------------------------------------------------------------
function changeNetworkSettings {
    $ip = "172.16.100.20"
    $gw = "172.16.100.10"
    New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress $ip -PrefixLength 24 -DefaultGateway $gw
    Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $gw, $ip
}
# -------------------------------------------------------------------------
# Join existing Domain
# -------------------------------------------------------------------------
function joinDomain {
    $domainname = "piet.periode1"
    $username = "$domainname\Administrator"
    $password = "P@ss123" | ConvertTo-SecureString -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($username, $password)
    Add-Computer -DomainName $domainname -Credential $credential
    Restart-computer
}
# -------------------------------------------------------------------------
# Install Domain Controller (Perform on Server Core)
# -------------------------------------------------------------------------
function changeDomain {
    $domainname = "piet.periode1"
    $password = "P@ss123" | ConvertTo-SecureString -AsPlainText -Force
    Install-WindowsFeature AD-Domain-Services -IncludeManagementTools 
    Install-ADDSDomainController -DomainName $domainname -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$True -SysvolPath "C:\Windows\SYSVOL" -SafeModeAdministratorPassword:($password) -Force:$true 
    Restart-computer
}
# -------------------------------------------------------------------------
# Configure DNS
# -------------------------------------------------------------------------
function configureDNS {
    $Forwarder = "8.8.8.8"
    Add-DnsServerForwarder -IPAddress $Forwarder -PassThru
}