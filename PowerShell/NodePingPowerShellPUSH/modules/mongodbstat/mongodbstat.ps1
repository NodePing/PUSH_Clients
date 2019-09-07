$user_input = Get-Content -Raw -Path $PSScriptRoot\mongodbstat.json | ConvertFrom-Json

$eval_string = $user_input.eval_string
$expected_output = $user_input.expected_output
$mongo_exe = $user_input.mongo_exe
$username = $user_input.username
$password = $user_input.password

if ( $username -eq "" -and $password -eq "" ) {
    $result = & $mongo_exe --quiet --eval "$eval_string"
} else {
    $result = & $mongo_exe --quiet --username "$username" --password "$password" --eval "$eval_string"
}

if ( $result -match $expected_output ) {
    Write-Output "1"
} else {
    Write-Output "0"
}
