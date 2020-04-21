$cpu_utilization = Get-WmiObject Win32_Processor | Select-Object LoadPercentage

Write-Output $cpu_utilization.LoadPercentage