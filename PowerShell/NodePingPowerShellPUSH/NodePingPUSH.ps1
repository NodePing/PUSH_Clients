Param(
	[string]$url = "https://push.nodeping.com/v1",
	[string]$logfile = "NodePingPUSH.log",
        [string]$checkid = "Your Check ID here",
        [string]$checktoken = "Your Check Token here",
	[switch]$debug = $False,
	[switch]$log = $True
)

$modules = Get-Content -Raw -Path moduleconfig.json | ConvertFrom-Json

$result = @{
    data = @{}
    id = $checkid
    checktoken = $checktoken
}

foreach( $module in $modules )
{
	$startInfo = New-Object System.Diagnostics.ProcessStartInfo
	$startInfo.FileName = $module.FileName
	$startInfo.Arguments = $module.Arguments
	$startInfo.RedirectStandardOutput = $true
	$startInfo.UseShellExecute = $false
	$startInfo.CreateNoWindow = $false

	$process = New-Object System.Diagnostics.Process
	$process.StartInfo = $startInfo
	$process.Start() | Out-Null
	$output = $process.StandardOutput.ReadToEnd()
	$process.WaitForExit()

	$result.data[ $module.Name ] = $output | ConvertFrom-Json
}

$json = $result | ConvertTo-Json -Compress


if( $debug ) {	
	echo $json	
} else {
	
	if( $log ) {
		Add-content $logfile -value "$(Get-Date -Format g ) => $json"
	}
	
	$response = Invoke-WebRequest -Uri $url -Method POST -ContentType "application/json" -Body $json	
	
	if( $log ) {
		Add-content $logfile -value "$(Get-Date -Format g ) <= $($response.StatusCode) $($response.Content)"
	}	
}