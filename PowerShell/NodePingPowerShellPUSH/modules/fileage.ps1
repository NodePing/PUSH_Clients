$files=@{
    "C:\Users\Administrator\Documents\hello.txt"=@{"days"=2; "hours"=0; "minutes"=0};
    "C:\Users\Adminstrator\Desktop\file1.docx"=@{"days"=1; "hours"=0; "minutes"=0};
    "C:\Users\Administrator\Documents\fileage.ps1"=@{"days"=0; "hours"=48; "minutes"=0}
}

$files_status=@{}

foreach ( $file in $files.GetEnumerator() ) {
    $filename = $file.Key

    if ((Test-Path $filename)) {
        $oldest_age = new-timespan -days $file.Value["days"] -hours $file.Value["hours"] -minutes $file.Value["minutes"]
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

Write-Output $files_status | ConvertTo-Json -Compress
