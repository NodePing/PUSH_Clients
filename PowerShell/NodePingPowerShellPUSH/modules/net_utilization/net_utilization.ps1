# two methods
# 1. Get stats, sit for X seconds, get stats and calculate
# 2. Get stats, get old stats from JSON file, calculate
$net_statistics = @{}
$new_statistics = @{}
$configs = Get-Content -Raw -Path $PSScriptRoot\net_utilization.json | ConvertFrom-Json
$last_stats = Get-Content -Raw -Path $PSScriptRoot\statistics.json | ConvertFrom-Json

$EachPush = $configs.EachPush
$SleepInterval = $configs.SleepInterval
$interfaces = $configs.interfaces
$ExpectedNetUtilizationRX = $configs.ExpectedNetUtilizationRX
$ExpectedNetUtilizationTX = $configs.ExpectedNetUtilizationTX

$net_stats =  Get-NetAdapterStatistics | Select-Object Name,ReceivedBytes,SentBytes

if ($EachPush -ne $TRUE) {
    Start-Sleep $SleepInterval
    $new_net_stats =  Get-NetAdapterStatistics | Select-Object Name,ReceivedBytes,SentBytes
}

foreach ($interface in $interfaces) {
    if ($EachPush -eq $TRUE) {
        $first_rx = $last_stats.$interface.rx
        $first_tx = $last_stats.$interface.tx
        $last_rx = $net_stats | Where-Object {$_.Name -Match "$interface"} | Select-Object ReceivedBytes
        $last_tx = $net_stats | Where-Object {$_.Name -Match "$interface"} | Select-Object SentBytes

        if ($last_rx.ReceivedBytes -lt $first_rx.ReceivedBytes) {
            Start-Sleep 5
            $new_net_stats =  Get-NetAdapterStatistics | Select-Object Name,ReceivedBytes,SentBytes

            $first_rx = $last_rx
            $first_tx = $last_tx
            $last_rx = $net_stats | Where-Object {$_.Name -Match "$interface"} | Select-Object ReceivedBytes
            $last_tx = $net_stats | Where-Object {$_.Name -Match "$interface"} | Select-Object SentBytes

            $rx = (($last_rx.ReceivedBytes - $first_rx.ReceivedBytes) / $SleepInterval) / 1000000
            $tx = (($last_tx.SentBytes - $first_tx.SentBytes) / $SleepInterval) / 1000000
        } else {
            $rx = (($last_rx.ReceivedBytes - $first_rx.ReceivedBytes) / $SleepInterval) / 1000000
            $tx = (($last_tx.SentBytes - $first_tx.SentBytes) / $SleepInterval) / 1000000
        }
    } else {
        $first_rx = $net_stats | Where-Object {$_.Name -Match "$interface"} | Select-Object ReceivedBytes
        $first_tx = $net_stats | Where-Object {$_.Name -Match "$interface"} | Select-Object SentBytes
        $last_rx = $new_net_stats | Where-Object {$_.Name -Match "$interface"} | Select-Object ReceivedBytes
        $last_tx = $new_net_stats | Where-Object {$_.Name -Match "$interface"} | Select-Object SentBytes

        $rx = (($last_rx.ReceivedBytes - $first_rx.ReceivedBytes) / $SleepInterval) / 1000000
        $tx = (($last_tx.SentBytes - $first_tx.SentBytes) / $SleepInterval) / 1000000
    }

    $rx_bytes = $last_rx.ReceivedBytes - $first_rx.ReceivedBytes
    $tx_bytes = $last_tx.SentBytes - $first_tx.SentBytes

    $rx_utilization = [math]::Round(($rx / $ExpectedNetUtilizationRX) * 100, 4)
    $tx_utilization = [math]::Round(($tx / $ExpectedNetUtilizationTX) * 100, 4)

    $net_statistics.Add("$interface", @{"rx_percent"=$rx_utilization; "tx_percent"=$tx_utilization; "rx_bytes"=$rx_bytes; "tx_bytes"=$tx_bytes})
    $new_statistics.Add("$interface", @{"name"="$interface"; "rx"=$last_rx; "tx"=$last_tx})

}
ConvertTo-Json $new_statistics | Out-File "$PSScriptRoot\statistics.json"
Write-Output $net_statistics
