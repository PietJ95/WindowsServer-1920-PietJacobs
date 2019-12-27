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

# -------------------------------------------------------------------------
# Configure admin accounts
# -------------------------------------------------------------------------
$OrganizationalUnit = "Users SP2016"
$Domain = "piet"
$DomainEnding = "periode1"

Import-Module ActiveDirectory

New-ADOrganizationalUnit -path "dc=$Domain, dc=$DomainEnding" -name $OrganizationalUnit -ProtectedFromAccidentalDeletion:$false  
New-ADUser -Path "OU=$OrganizationalUnit,DC=$Domain,DC=$DomainEnding" -Name "spAdmin" -AccountPassword (ConvertTo-SecureString "Password123" –AsPlaintext –Force) -Description "SharePoint Setup Account" -ChangePasswordAtLogon:$False -CannotChangePassword:$True -PasswordNeverExpires:$True -Enabled:$True  
New-ADUser -Path "OU=$OrganizationalUnit,DC=$Domain,DC=$DomainEnding" -Name "sqlSvcAcc" -AccountPassword (ConvertTo-SecureString "Password123" –AsPlaintext –Force) -Description "SQL Server Service Account" -ChangePasswordAtLogon:$False -CannotChangePassword:$True -PasswordNeverExpires:$True -Enabled:$True  
New-ADUser -Path "OU=$OrganizationalUnit,DC=$Domain,DC=$DomainEnding" -Name "spFarmAcc" -AccountPassword (ConvertTo-SecureString "Password123" –AsPlaintext –Force) -Description "SharePoint Farm Account" -ChangePasswordAtLogon:$False -CannotChangePassword:$True -PasswordNeverExpires:$True -Enabled:$True  
New-ADUser -Path "OU=$OrganizationalUnit,DC=$Domain,DC=$DomainEnding" -Name "spAppPool" -AccountPassword (ConvertTo-SecureString "Password123" –AsPlaintext –Force) -Description "SharePoint Application Pool Account" -ChangePasswordAtLogon:$False -CannotChangePassword:$True -PasswordNeverExpires:$True -Enabled:$True  

# -------------------------------------------------------------------------
# Configure admin accounts
# -------------------------------------------------------------------------
$domain = "piet.periode1"
$strComputer = "localhost"
$username = "spAdmin"
$computer = [ADSI]("WinNT://" + $strComputer + ",computer")
$computer.name
$Group = $computer.psbase.children.find("administrators")
$Group.name
$Group.Add("WinNT://" + $domain + "/" + $username)

# -------------------------------------------------------------------------
# Cofigure role
# -------------------------------------------------------------------------
Write-Host " - Importing Module Servermanager..."  
Import-Module Servermanager

Write-Host " - Installing .NET Framework Feature..."  
get-windowsfeature|where{$_.name -eq "NET-Framework-Core"}|install-windowsfeature –Source d:\sources\sxs  
get-windowsfeature|where{$_.name -eq "NET-HTTP-Activation"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "NET-Non-HTTP-Activ"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "NET-WCF-HTTP-Activation45"}|install-windowsfeature

Write-Host " - Installing 'Application Server' role..."  
get-windowsfeature|where{$_.name -eq "AS-AppServer-Foundation"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "AS-Web-Support"}|install-windowsfeature  
#get-windowsfeature|where{$_.name -eq "AS-TCP-Port-Sharing"}|install-windowsfeature
#get-windowsfeature|where{$_.name -eq "AS-WAS-Support"}|install-windowsfeature
#get-windowsfeature|where{$_.name -eq "AS-HTTP-Activation"}|install-windowsfeature
#get-windowsfeature|where{$_.name -eq "AS-Named-Pipes"}|install-windowsfeature
#get-windowsfeature|where{$_.name -eq "AS-TCP-Activation"}|install-windowsfeature

Write-Host " - Installing 'Web Server' role..."  
get-windowsfeature|where{$_.name -eq "Web-Static-Content"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-Default-Doc"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-Dir-Browsing"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-Http-Errors"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-Http-Redirect"}|install-windowsfeature

get-windowsfeature|where{$_.name -eq "Web-App-Dev"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-Asp-Net45"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-Net-Ext"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-Net-Ext45"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-ISAPI-Ext"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-ISAPI-Filter"}|install-windowsfeature

get-windowsfeature|where{$_.name -eq "Web-Http-Logging"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-Log-Libraries"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-Request-Monitor"}|install-windowsfeature  
#get-windowsfeature|where{$_.name -eq "Web-Http-Tracing"}|install-windowsfeature

get-windowsfeature|where{$_.name -eq "Web-Stat-Compression"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-Dyn-Compression"}|install-windowsfeature

get-windowsfeature|where{$_.name -eq "Web-Filtering"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-Basic-Auth"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-Windows-Auth"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-Digest-Auth"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-Client-Auth"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-Cert-Auth"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-Url-Auth"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-IP-Security"}|install-windowsfeature

get-windowsfeature|where{$_.name -eq "Web-Mgmt-Tools"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-Mgmt-Console"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-Mgmt-Compat"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-Metabase"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-Lgcy-Mgmt-Console"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-Lgcy-Scripting"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-WMI"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "Web-Scripting-Tools"}|install-windowsfeature

Write-Host " - Installing WAS Feature..."  
get-windowsfeature|where{$_.name -eq "WAS-Process-Model"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "WAS-NET-Environment"}|install-windowsfeature  
get-windowsfeature|where{$_.name -eq "WAS-Config-APIs"}|install-windowsfeature

Write-Host " - Installing Windows Identity Foundation Feature..."  
get-windowsfeature|where{$_.name -eq "Windows-Identity-Foundation"}|install-windowsfeature

# -------------------------------------------------------------------------
# Give spAdmin the proper rights
# -------------------------------------------------------------------------
#SQL QUERY EXECUTED ON OTHER SERVER


# -------------------------------------------------------------------------
# Download Sharepoint & Prerequisites
# -------------------------------------------------------------------------
# The top-level folder in the installation folder tree
$RootFolder = "C:\SharePointInstall"

# The folder for prerequisites installed before the Prerequisite Installer
# There are a number of updates to Windows Server 2012 R2 that must be installed
# before SharePoint Server 2016's Prerequisite Installer can be run
$Prereqs1Folder = "$RootFolder\SharePoint_Prerequisites\Windows_Server_2012_R2_Updates"

# The folder for prerequisites used by the Prerequisite Installer
$Prereqs2Folder = "$RootFolder\SharePoint_Prerequisites\PrerequisiteInstaller"

# END CONFIGURATION BLOCK
# -----------------------

# ----------------------------------------------------------------
# Download details
# Do not change unless Microsoft changes the downloads themselves
# ----------------------------------------------------------------

# Specify download url's for SharePoint 2016 prerequisites
$Downloads = @{
            # AppFabric
            "https://download.microsoft.com/download/F/1/0/F1093AF6-E797-4CA8-A9F6-FC50024B385C/AppFabric-KB3092423-x64-DEU.exe" = "$Prereqs1Folder\AppFabric-KB3092423-x64-DEU.exe";
            # Microsoft ODBC Driver 11 for SQL Server http://go.microsoft.com/fwlink/?LinkId=618410
            "https://download.microsoft.com/download/5/7/2/57249A3A-19D6-4901-ACCE-80924ABEB267/ENU/x64/msodbcsql.msi" = "$Prereqs2Folder\msodbcsql.msi";
            # Microsoft Sync Framework Runtime v1.0 SP1 (x64) http://go.microsoft.com/fwlink/?LinkId=618411
            "https://download.microsoft.com/download/E/0/0/E0060D8F-2354-4871-9596-DC78538799CC/Synchronization.msi" = "$Prereqs2Folder\Synchronization.msi";
            # Windows Identity Foundation (KB974405)
            "http://download.microsoft.com/download/D/7/2/D72FD747-69B6-40B7-875B-C2B40A6B2BDD/Windows6.1-KB974405-x64.msu" = "$Prereqs2Folder\Windows6.1-KB974405-x64.msu";
            # Microsoft Identity Extensions
            # http://go.microsoft.com/fwlink/?LinkID=252368
            "http://download.microsoft.com/download/0/1/D/01D06854-CA0C-46F1-ADBA-EBF86010DCC6/rtm/MicrosoftIdentityExtensions-64.msi" = "$Prereqs2Folder\MicrosoftIdentityExtensions-64.msi";
            # Microsoft Information Protection and Control Client http://go.microsoft.com/fwlink/?LinkID=544913
            # MSI version (does not satisfy Prerequisite Installer):
            #     http://go.microsoft.com/fwlink/?LinkId=320724
            #     https://download.microsoft.com/download/9/1/D/91DA8796-BE1D-46AF-8489-663AB7811517/setup_msipc_x64.msi
            "http://download.microsoft.com/download/3/C/F/3CF781F5-7D29-4035-9265-C34FF2369FA2/setup_msipc_x64.exe" = "$Prereqs2Folder\setup_msipc_x64.exe";
            # Microsoft WCF Data Services 5.6 required for SharePoint 2013 SP1 http://go.microsoft.com/fwlink/?LinkId=320724
            "https://download.microsoft.com/download/1/C/A/1CAA41C7-88B9-42D6-9E11-3C655656DAB1/WcfDataServices.exe" = "$Prereqs2Folder\WcfDataServices56.exe";
            # .NET Framework 4.6 Offline Installer http://go.microsoft.com/fwlink/?LinkId=618401
            "https://download.microsoft.com/download/C/3/A/C3A5200B-D33C-47E9-9D70-2F7C65DAAD94/NDP46-KB3045557-x86-x64-AllOS-ENU.exe" = "$Prereqs2Folder\NDP46-KB3045557-x86-x64-AllOS-ENU.exe";
            # Cumulative Update Package 7 for AppFabric 1.1 for Windows Server https://support.microsoft.com/en-us/kb/3092423
            "https://download.microsoft.com/download/F/1/0/F1093AF6-E797-4CA8-A9F6-FC50024B385C/AppFabric-KB3092423-x64-ENU.exe" = "$Prereqs2Folder\AppFabric-KB3092423-x64-ENU.exe";
            # Visual C++ Redistributable for Visual Studio 2012 Update 4 http://go.microsoft.com/fwlink/?LinkId=327788
            "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe" = "$Prereqs2Folder\vcredist_x64.exe";
            # Visual C++ Redistributable for Visual Studio 2015 http://go.microsoft.com/fwlink/?LinkId=623013
            "http://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x64.exe" = "$Prereqs2Folder\vc_redist.x64.exe"
            # Silverlight http://go.microsoft.com/fwlink/p/?LinkId=166506
            "http://silverlight.dlservice.microsoft.com/download/F/8/C/F8C0EACB-92D0-4722-9B18-965DD2A681E9/30514.00/Silverlight_x64.exe" = "$Prereqs3Folder\Silverlight_x64.exe";
            # Exchange Web Services Managed API, version 1.2 http://go.microsoft.com/fwlink/p/?linkid=238668
            "https://download.microsoft.com/download/7/6/1/7614E07E-BDB8-45DD-B598-952979E4DA29/EwsManagedApi.msi" = "$Prereqs3Folder\EwsManagedApi.msi";
            # Windows Server 2012 R2 clearcompressionflag.exe
            "https://download.microsoft.com/download/2/5/6/256CCCFB-5341-4A8D-A277-8A81B21A1E35/clearcompressionflag.exe" = "$Prereqs1Folder\clearcompressionflag.exe";

            "https://download.microsoft.com/download/A/6/7/A678AB47-496B-4907-B3D4-0A2D280A13C0/WindowsServerAppFabricSetup_x64.exe" = "$Prereqs1Folder\WindowsServerAppFabricSetup_x64.exe";

            "https://download.microsoft.com/download/B/E/D/BED73AAC-3C8A-43F5-AF4F-EB4FEA6C8F3A/ENU/x64/sqlncli.msi" = "$Prereqs1Folder\sqlncli.msi";
            "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU4/vcredist_arm.exe" = "$Prereqs1Folder\vcredist_arm.exe";
            #"https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe" = "$Prereqs1Folder\vcredist_x64.exe";
            } 


# Import Required Modules: BITS is used for file transfer
Import-Module BitsTransfer 

function DownloadFiles()  
{ 

    Write-Host ""
    Write-Host "====================================================================="
    Write-Host "             Downloading SharePoint 2016 Prerequisites" 
    Write-Host "====================================================================="

    $ReturnCode = 0 

    $Downloads.GetEnumerator() | ForEach { 
        $DownloadURL = $_.get_key()
        $Filespec = $_.get_value()
        # Get the file name based on the portion of the file path after the last slash 
        $FilePath = Split-Path $Filespec
        $FileName = Split-Path $Filespec -Leaf
        Write-Host "DOWNLOADING: $FileName"
        Write-Host "       FROM: $DownloadURL"
        Write-Host "         TO: $FilePath"

        Try 
        { 
            # Check if file already exists 
            If (!(Test-Path "$Filespec")) 
            { 
                # Begin download 
                Start-BitsTransfer -Source $DownloadURL -Destination "$Filespec" -DisplayName "Downloading `'$FileName`' to $FilePath" -Priority High -Description "From $DownloadURL..." -ErrorVariable err 
                If ($err) {Throw ""} 
                Write-Host "     STATUS: Downloaded"
                Write-Host
            } 
            Else 
            { 
                Write-Host "     STATUS: Already exists. Skipping." 
                Write-Host
            } 
        } 
        Catch 
        { 
            $ReturnCode = -1
            Write-Warning " AN ERROR OCCURRED DOWNLOADING `'$FileName`'" 
            Write-Error   $_
            Break 
        } 

    } 
    return $ReturnCode 
} 

$rc = DownloadFiles 

if($rc -ne -1)  
{
    Write-Host ""
    Write-Host "DOWNLOADS ARE COMPLETE."
}


# -------------------------------------------------------------------------
# Install Sharepoint
# -------------------------------------------------------------------------
Start-Process "d:\setup.exe" -ArgumentList "/config `"$PSScriptRoot\sharepoint.xml`"" -WindowStyle Minimized -wait 


# -------------------------------------------------------------------------
# Create Sharepoint farm
# -------------------------------------------------------------------------
$DBServer = 'WIN-SQL-SCCM.piet.periode1'
$ConfigDB = 'spFarmConfiguration'
$CentralAdminContentDB = 'spCentralAdministration'
$CentralAdminPort = '2016'
$PassPhrase = 'Password123'
$SecPassPhrase = ConvertTo-SecureString $PassPhrase –AsPlaintext –Force

$FarmAcc = 'PIET\spFarmAcc'
$FarmPassword = 'Password123'
$FarmAccPWD = ConvertTo-SecureString $FarmPassword  –AsPlaintext –Force
$cred_FarmAcc = New-Object System.Management.Automation.PsCredential $FarmAcc,$FarmAccPWD 
#--WebFrontEnd, Application, DistributedCache, Search, Custom, SingleServerFarm
$ServerRole = "Custom"



Write-Host " - Enabling SP PowerShell cmdlets..."  
If ((Get-PsSnapin |?{$_.Name -eq "Microsoft.SharePoint.PowerShell"})-eq $null)  
{
    Add-PsSnapin Microsoft.SharePoint.PowerShell | Out-Null
}
Start-SPAssignment -Global | Out-Null



Write-Host " - Creating configuration database..."  
New-SPConfigurationDatabase –DatabaseName "$ConfigDB" –DatabaseServer "$DBServer" –AdministrationContentDatabaseName "$CentralAdminContentDB" –Passphrase $SecPassPhrase –FarmCredentials $cred_FarmAcc -LocalServerRole $ServerRole

Write-Host " - Installing Help Collection..."  
Install-SPHelpCollection -All

Write-Host " - Securing Resources..."  
Initialize-SPResourceSecurity

Write-Host " - Installing Services..."  
Install-SPService

Write-Host " - Installing Features..."  
$Features = Install-SPFeature –AllExistingFeatures -Force

Write-Host " - Creating Central Admin..."  
$NewCentralAdmin = New-SPCentralAdministration -Port $CentralAdminPort -WindowsAuthProvider "NTLM"

Write-Host " - Waiting for Central Admin to provision..." -NoNewline  
sleep 15 
Write-Host "Created!"

Write-Host " - Installing Application Content..."  
Install-SPApplicationContent



Stop-SPAssignment -Global | Out-Null 





