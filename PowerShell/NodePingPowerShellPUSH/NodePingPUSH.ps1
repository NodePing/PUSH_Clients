Param(
	[string]$url = "https://push.nodeping.com/v1",
	[string]$logfile = "NodePingPUSH.log",
	[string]$checkid = "Your Check ID here",
	[string]$checktoken = "Your Check Token here",
	[switch]$debug = $False,
	[switch]$log = $True
)

$moduleconfig = "$PSScriptRoot\moduleconfig.json"

$modules = Get-Content -Raw -Path $moduleconfig | ConvertFrom-Json

$result = @{
    data = @{}
    id = $checkid
    checktoken = $checktoken
}

foreach( $module in $modules )
{
	$arguments = $module.Arguments
	$script = "$PSScriptRoot\$arguments"
	$output = & $script 2>&1 | ConvertTo-Json -Compress | Out-String

	$result.data[ $module.Name ] = $output | ConvertFrom-Json
}

$json = $result | ConvertTo-Json -Compress


if( $debug ) {	
	Write-Output $json	
} else {
	
	if( $log ) {
		Add-content $logfile -value "$(Get-Date -Format g ) => $json"
	}
	
	$response = Invoke-WebRequest -Uri $url -UseBasicParsing -Method POST -ContentType "application/json" -Body $json	
	
	if( $log ) {
		Add-content $logfile -value "$(Get-Date -Format g ) <= $($response.StatusCode) $($response.Content)"
	}	
}
