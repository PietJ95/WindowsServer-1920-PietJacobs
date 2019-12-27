# -------------------------------------------------------------------------
# Install Chocolatey
# -------------------------------------------------------------------------
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))


# -------------------------------------------------------------------------
# Install SQL
# -------------------------------------------------------------------------
choco install sql-server-management-studio -y
choco install sql-server-express --params='/ConfigurationFile="SQL_config.ini"' -y
choco install webdeploy -y

# -------------------------------------------------------------------------
# Install requirements for SCCM
# -------------------------------------------------------------------------
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


# SCCM
# -------------------------------------------------------------------------
# Install Windows 10 ADK
# -------------------------------------------------------------------------
$ADKDownloadLink = "http://go.microsoft.com/fwlink/p/?LinkId=526740&ocid=tia-235208000"
Invoke-WebRequest $ADKDownloadLink -OutFile ADK.exe
ADK.exe /installpath "C:\Program Files (x86)\Windows Kits\10" /features OptionId.DeploymentTools OptionId.UserStateMigrationTool OptionId.WindowsPreinstallationEnvironment /ceip off /norestart
