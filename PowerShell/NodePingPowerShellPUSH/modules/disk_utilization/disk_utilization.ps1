$diskspace_percentages = @{}

#Get disk Size
$drive_info = Get-PSDrive -PSProvider FileSystem | Select-Object Name,Used,Free

$drive_info | ForEach-Object {
    $drive_letter = $_.Name
    $used = $_.Used
    $free = $_.Free
    $total = $used + $free

    if (! $free -or ! $used) {
        return
    }

    $used_percent = [math]::Round(($used / $total) * 100, 2)
    
    $diskspace_percentages.Add($drive_letter, $used_percent)
}

Write-Output $diskspace_percentages