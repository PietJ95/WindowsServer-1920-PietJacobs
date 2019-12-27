# -------------------------------------------------------------------------
# Failover DHCP
# -------------------------------------------------------------------------
Set-ExecutionPolicy -ExecutionPolicy ByPass
Add-DhcpServerv4Failover -ComputerName WIN-DC1 -Name win-dc1.piet.periode1-win-dc2_loadbalance -LoadBalancePercent 50 -MaxClientLeadTime 1:00:00 -StateSwitchInterval 00:45:00 -PartnerServer WIN-DC2 -ScopeId 192.168.100.0 -SharedSecret "Password123"