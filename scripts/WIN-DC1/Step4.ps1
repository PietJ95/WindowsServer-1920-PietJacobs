# -------------------------------------------------------------------------
# Configure RRAS
# -------------------------------------------------------------------------
Install-RemoteAccess -VpnType Vpn
$ExternalInterface = "Ethernet 2"
$InternalInterface = "Ethernet"
cmd.exe /c "netsh routing ip nat add interface $ExternalInterface"
cmd.exe /c "netsh routing ip nat set interface $ExternalInterface mode=full"
cmd.exe /c "netsh routing ip nat add interface $InternalInterface"