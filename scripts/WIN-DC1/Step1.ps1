# -------------------------------------------------------------------------
# Set Hostname
# -------------------------------------------------------------------------
$hostname = "WIN-DC1"
Rename-Computer -ComputerName $env:COMPUTERNAME -newName $hostname -Force

# Unblock scripts for instant use on next boot
Unblock-File -Path Z:\Step2.ps1
Unblock-File -Path Z:\Step3.ps1

# Set NextRun script
$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
Set-ItemProperty $RunOnceKey "NextRun" "C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -ExecutionPolicy Unrestricted -File Z:\Step2.ps1"
Restart-Computer