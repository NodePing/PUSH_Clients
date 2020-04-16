Param(
	[string]$url = "https://push.nodeping.com/v1",
	[string]$logfile = "$PSScriptRoot\NodePingPUSH.log",
	[string]$checkid = "Your Check ID here",
	[string]$checktoken = "Your Check Token here",
	[int]$timeout = 5,
	[int]$retries = 3,
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

$json = $result | ConvertTo-Json -Compress -Depth 4


if( $debug ) {	
	Write-Output $json	
} else {
	
	if( $log ) {
		Add-content $logfile -value "$(Get-Date -Format g ) => $json"
	}
	
	# Need to write custom retry code to support Powershell versions <6.0
	$tries = $retries + 1

	while ( $tries -gt 0 ) {
		try {
			$response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec $timeout -Method POST -ContentType "application/json" -Body $json
			$StatusCode = $response.StatusCode
		}
		catch {
				$StatusCode = $_.Exception.Response.StatusCode.value__
		}

		if ( $StatusCode -eq 200 -or $StatusCode -eq 409) {
			$tries = 0
		} else {
			$tries -= 1
		}
		


	}
	
	if( $log ) {
		Add-content $logfile -value "$(Get-Date -Format g ) <= $($response.StatusCode) $($response.Content)"
	}	
}
