# -------------------------------------------------------------------------
# Set hostname
# -------------------------------------------------------------------------
function setHostname {
    $hostname = "WIN-SQL-SCCM"
    Rename-Computer -ComputerName $env:COMPUTERNAME -newName $hostname -Force
    Restart-Computer
}
# -------------------------------------------------------------------------
# Configure network settings
# -------------------------------------------------------------------------
function configureNetworkSettings {
    $ip = "192.168.100.30"
    $gw = "192.168.100.10"
    $dns = "192.168.100.10"
    New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress $ip -PrefixLength 24 -DefaultGateway $gw
    Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses $gw, $dns
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
# Install SQL Server (Perform on Server Core)
# -------------------------------------------------------------------------
Function installSQL {
    $sqlDownloadLink = "https://go.microsoft.com/fwlink/?linkid=853017"
    Set-Location C:/
    Invoke-WebRequest $sqlDownloadLink -OutFile SQLServer.exe
    Start-Process -FilePath ./SQLServer.exe -ArgumentList "/action=download /quiet /enu /MediaPath=C:/" -wait
    Remove-Item ./SQLServer.exe
    Start-Process -FilePath C:/SQLEXPR_x64_ENU.exe -WorkingDirectory C:/ /qs -wait
    Start-Process -FilePath C:/SQLEXPR_x64_ENU/SETUP.EXE -ArgumentList "/Q /Action=install /IAcceptSQLServerLicenseTerms /FEATURES=SQL,RS,Tools /TCPENABLED=1 /SECURITYMODE=`"SQL`" /SQLSVCACCOUNT="$domainName\Administrator" /SQLSYSADMINACCOUNTS=`"$domainName\Domain Admins`" /INSTANCENAME=`"MSSQLSERVER`" /INSTANCEID=`"SQL`" /AGTSVCACCOUNT="NT AUTHORITY\Network Service" SQLCOLLATION=SQL_Latin1_General_CP1_CI_AS /SQLSVCPASSWORD=`"P@ss123`"" -wait
}
# -------------------------------------------------------------------------
#Install SSMS
# -------------------------------------------------------------------------
Function installSSMS {
    $SSMSDownloadLink = "https://go.microsoft.com/fwlink/?linkid=858904"
    Set-Location C:/
    Invoke-WebRequest $SSMSDownloadLink -OutFile SSMS.exe
    Start-Process -FilePath "C:\SSMS.exe" -ArgumentList '/s' -Wait -PassThru
}

# -------------------------------------------------------------------------
# Install requirements for SCCM
# -------------------------------------------------------------------------
function installPrerequisites { 
    Get-Module servermanager
    Install-WindowsFeature Web-Windows-Auth         
    Install-WindowsFeature Web-ISAPI-Ext
    Install-WindowsFeature Web-Metabase
    Install-WindowsFeature Web-WMI
    Install-WindowsFeature BITS
    Install-WindowsFeature RDC
    Install-WindowsFeature NET-Framework-Features
    Install-WindowsFeature Web-Asp-Net
    Install-WindowsFeature Web-Asp-Net45
    Install-WindowsFeature NET-HTTP-Activation
    Install-WindowsFeature NET-Non-HTTP-Activ
    Install-WindowsFeature WDS
    dism /online /enable-feature /featurename:NetFX3 /all /Source:d:\sources\sxs /LimitAccess
}

# SCCM
# -------------------------------------------------------------------------
# Install Windows 10 ADK
# -------------------------------------------------------------------------
function installADK {
    $ADKDownloadLink = "http://go.microsoft.com/fwlink/p/?LinkId=526740&ocid=tia-235208000"
    Invoke-WebRequest $ADKDownloadLink -OutFile ADK.exe
    ADK.exe /installpath "C:\Program Files (x86)\Windows Kits\10" /features OptionId.DeploymentTools OptionId.UserStateMigrationTool OptionId.WindowsPreinstallationEnvironment /ceip off /norestart
}

#...