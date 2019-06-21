$files = Get-Content -Raw -Path $PSScriptRoot\fileage.json | ConvertFrom-Json

$files_status=@{}

foreach ( $file in $files ) {
    $filename = $file.FileName
    $days = $file.Age.days
    $hours = $file.Age.hours
    $minutes = $file.Age.minutes

    if ((Test-Path $filename)) {
        $oldest_age = new-timespan -days $days -hours $hours -minutes $minutes
        $last_write = (get-item $filename).LastWriteTime

        if (((get-date) - $last_write) -gt $oldest_age) {
            $files_status.Add($filename, 0)
        } else {
            $files_status.Add($filename, 1)
        }
    } else {
        $files_status.Add($filename, 0)
    }
}

Write-Output $files_status
