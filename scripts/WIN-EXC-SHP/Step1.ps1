# -------------------------------------------------------------------------
# Change hostname
# -------------------------------------------------------------------------
$hostname = "WIN-EXC-SHP"
Rename-Computer -ComputerName $env:COMPUTERNAME -newName $hostname -Force
#Unblock scripts that were downloaded from internet (Github repo)
Unblock-File -Path C:\scripts\Step1.ps1
Unblock-File -Path C:\scripts\Step2.ps1
Unblock-File -Path C:\scripts\Step3.ps1
Unblock-File -Path C:\scripts\Step4.ps1
Unblock-File -Path C:\scripts\Step5.ps1
Set-ItemProperty $RunOnceKey "NextRun" "C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -ExecutionPolicy Unrestricted -File C:\scripts\Step2.ps1"
Restart-Computer


