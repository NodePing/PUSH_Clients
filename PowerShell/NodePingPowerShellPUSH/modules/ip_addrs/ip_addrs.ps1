$acceptable_ips = Get-Content -Raw -Path $PSScriptRoot\ip_addrs.json | ConvertFrom-Json

$ips = Get-NetIPAddress | Select-Object -Property IPAddress

foreach ( $ip in $ips ) {
    $addr = $ip.IPAddress

    if ($acceptable_ips -contains $addr) {
        continue
    } elseif ($addr -eq "127.0.0.1") {
        continue
    } elseif ($addr -eq "::1") {
        continue
    } elseif ($addr.StartsWith("fe80")) {
        continue
    } elseif ($addr -match "'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$'") {
        continue
    } elseif ($acceptable_ips -notcontains $addr) {
        Write-Output "0"
        Exit
    }
}

Write-Output "1"
