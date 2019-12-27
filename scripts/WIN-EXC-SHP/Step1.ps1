# -------------------------------------------------------------------------
# Change hostname
# -------------------------------------------------------------------------
$hostname = "WIN-EXC-SHP"
Rename-Computer -ComputerName $env:COMPUTERNAME -newName $hostname -Force
$RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
Set-ItemProperty $RunOnceKey "NextRun" "C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -ExecutionPolicy Unrestricted -File Z:\Step2.ps1"
Restart-Computer


