$user_input = Get-Content -Raw -Path $PSScriptRoot\mongodbstat.json | ConvertFrom-Json

$eval_string = $user_input.eval_string
$expected_output = $user_input.expected_output
$mongo_exe = $user_input.mongo_exe

$result = & $mongo_exe --eval "$eval_string"

if ( $result -contains $expected_output ) {
    Write-Output "1"
} else {
    Write-Output "0"
}
