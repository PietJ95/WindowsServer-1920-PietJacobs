# -------------------------------------------------------------------------
# Failover DHCP
# -------------------------------------------------------------------------
Set-ExecutionPolicy -ExecutionPolicy ByPass
Add-DhcpServerv4Failover -ComputerName WIN-DC1.piet.periode1 -Name win-dc1.piet.periode1-win-dc2 -PartnerServer WIN-DC2.piet.periode1 -ScopeId 192.168.100.0 -Force