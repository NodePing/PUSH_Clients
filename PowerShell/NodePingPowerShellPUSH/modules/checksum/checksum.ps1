$files = Get-Content -Raw -Path modules\checksum\checksum.json | ConvertFrom-Json

$hash_status=@{}

foreach ( $file in $files ) {
    $filename = $file.FileName
    $stored_hash = $file.Hash
    $hash_algorithm = $file.HashAlgorithm

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