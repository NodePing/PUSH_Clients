$files = Get-Content -Raw -Path modules\checksum.json | ConvertFrom-Json

# SHA1, SHA256, SHA384, SHA512, MD5
$hash_algorithm = "SHA256"

$hash_status=@{}

foreach ( $file in $files ) {
    $filename = $file.FileName
    $stored_hash = $file.Hash

    if (( Test-Path $filename )) {
        $get_hash = Get-FileHash $filename -Algorithm $hash_algorithm
		$new_hash = $get_hash.Hash
		
        if ( $stored_hash -eq $new_hash ) {
            $hash_status.Add($filename, 1)
        } else {
            $hash_status.Add($filename, 0)
        }        
    } else {
        $hash_status.Add($filename, 0)
    }

}

Write-Output $hash_status