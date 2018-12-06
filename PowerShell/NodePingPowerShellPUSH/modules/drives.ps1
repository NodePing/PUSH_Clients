$drives = Get-PSDrive -PSProvider FileSystem

$result = @{}

foreach( $drive in $drives ) {
	if($drive.free){
		$result[$drive.Name] = [math]::Round( $drive.Free / ( $drive.Free + $drive.Used ), 2 )
	}
}

Write-Output $result