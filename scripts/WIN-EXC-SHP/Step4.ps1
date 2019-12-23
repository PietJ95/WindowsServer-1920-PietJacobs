# -------------------------------------------------------------------------
# Installing Exchange Server
# -------------------------------------------------------------------------
$domainName = "piet.periode1"
$exchangeDownloadLink = "https://download.microsoft.com/download/f/4/e/f4e4b3a0-925b-4eff-8cc7-8b5932d75b49/ExchangeServer2016-x64-cu14.iso"
Set-Location C:/
Invoke-WebRequest $exchangeDownloadLink -OutFile Exchange.iso
Mount-DiskImage -ImagePath .\Exchange.iso
$exchangeISO = (Get-DiskImage ".\Exchange.iso" | Get-Volume).DriveLetter
Install-WindowsFeature RSAT-ADDS
Set-Location $exchangeISO
.\Setup.exe /PrepareSchema /IAcceptExchangeServerLicenseTerms 
.\Setup.exe /PrepareAD /OrganizationName:$domainName /IAcceptExchangeServerLicenseTerms
#Install prerequisites
Install-WindowsFeature NET-Framework-45-Features, RPC-over-HTTP-proxy, RSAT-Clustering, RSAT-Clustering-CmdInterface, RSAT-Clustering-Mgmt, RSAT-ADDS, RSAT-Clustering-PowerShell, Web-Mgmt-Console, WAS-Process-Model, Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Lgcy-Mgmt-Console, Web-Metabase, Web-Mgmt-Console, Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, Windows-Identity-Foundation
.\Setup.exe /M:Install /R:Mailbox, ManagementTools /IAcceptExchangeServerLicenseTerms
