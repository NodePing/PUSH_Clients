$processor = Get-WmiObject Win32_Processor | Measure-Object -property LoadPercentage -Average

echo ([math]::Round( $processor.Average / 100.0, 2 ))