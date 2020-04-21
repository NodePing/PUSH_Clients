$total_mem = ((Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | Select-Object sum).Sum / 1024)

$memory = Get-WmiObject Win32_OperatingSystem
$free = $memory.FreePhysicalMemory

$used_mem = $total_mem - $free
$used_percent = [math]::Round(($used_mem / $total_mem) * 100, 2)

Write-Output $used_percent