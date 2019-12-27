$chromeEnterpriseDownloadLink = https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7BAB3972F4-91EE-53EB-4009-AFA933E367B2%7D%26lang%3Den%26browser%3D4%26usagestats%3D1%26appname%3DGoogle%2520Chrome%26needsadmin%3Dtrue%26ap%3Dx64-stable-statsdef_0%26brand%3DGCEB/dl/chrome/install/GoogleChromeEnterpriseBundle64.zip
$UCMADownloadLink = https://download.microsoft.com/download/3/9/B/39B042C0-8ACB-4D1A-BE02-4E20247A36E6/UcmaSdkSetup.exe
$DOTNETDownloadLink = https://download.visualstudio.microsoft.com/download/pr/c76aa823-bbc7-4b21-9e29-ab24ceb14b2d/9de2e14be600ef7d5067c09ab8af5063/dotnet-sdk-2.2.401-win-x64.exe
$VCRedistDownloadLink = https://aka.ms/vs/16/release/vc_redist.x64.exe
Set-Location C:/
Invoke-WebRequest $chromeEnterpriseDownloadLink -OutFile GoogleChromeEnterpriseBundle.zip
Expand-Archive GoogleChromeEnterpriseBundle.zip
Invoke-WebRequest $UCMADownloadLink -OutFile UCMA.exe
Invoke-WebRequest $DOTNETDownloadLink -OutFile DOTNET.exe
Invoke-WebRequest $VCRedistDownloadLink -OutFile VCRedist.exe 
.\GoogleChromeEnterpriseBundle64.zip\Installers\GoogleChromeStandaloneEnterprise64.msi /q
.\UCMA.exe -q
.\DOTNET.exe /passive /norestart
.\VCRedist.exe /passive /norestart
$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
Set-ItemProperty $RunOnceKey "NextRun" "C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -ExecutionPolicy Unrestricted -File Z:\Step4.ps1"
Restart-Computer