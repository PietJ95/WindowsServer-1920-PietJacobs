# -------------------------------------------------------------------------
# Join existing Domain
# -------------------------------------------------------------------------
# Set NextRun script
Set-ItemProperty $RunOnceKey "NextRun" "C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -ExecutionPolicy Unrestricted -File C:\scripts\Step3.ps1"

$domainname = "piet.periode1"
$username = "$domainname\Administrator"
$password = "P@ss123" | ConvertTo-SecureString -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username, $password)
Add-Computer -DomainName $domainname -Credential $credential
Restart-computer