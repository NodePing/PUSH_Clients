$configs = Get-Content -Raw -Path $PSScriptRoot\httpcheck.json | ConvertFrom-Json

$results=@{}

$url = $configs.url
$http_method = $configs.http_method
$content_type = $configs.content_type
$data = $configs.data


# Get time_total for Invoke-WebRequest execution
$time = Measure-Command -Expression {
    if ( $http_method -eq "GET"  -or $http_method -eq "DELETE" ) {
        $output = Invoke-WebRequest -Method $http_method -UseBasicParsing -Uri $url
    } elseif ($http_method -eq "POST" -or $http_method -eq "PUT" ) {
        $output = Invoke-WebRequest -UseBasicParsing -Uri $url -Method $http_method  -ContentType "$content_type" -Body $data
    }
    
}

$results.Add("time_total", $time.TotalSeconds)
$results.Add("http_code", $output.StatusCode)

Write-Output $results
