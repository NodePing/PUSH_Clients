Param(
	[string]$url = "https://push.nodeping.com/v1",
	[string]$logfile = "NodePingPUSH.log",
        [string]$checkid = "Your Check ID here",
        [string]$checktoken = "Your Check Token here",
	[switch]$debug = $True,
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
	$script = $module.Arguments
	$output = & .\$script 2>&1 | Out-String

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
