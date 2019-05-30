$processor = Get-WmiObject Win32_Processor | Measure-Object -property LoadPercentage -Average

Write-Output ([math]::Round( $processor.Average / 100.0, 2 ))