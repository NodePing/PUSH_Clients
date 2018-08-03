$memory = Get-WmiObject Win32_OperatingSystem
$free = [math]::floor( $memory.FreePhysicalMemory / 1024 )
	
echo $free