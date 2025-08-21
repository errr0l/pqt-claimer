$content = Get-Content (Join-Path $PSScriptRoot requests_ps.txt) -Raw

$processed = $content -replace '\\\n\s+', '' 

$parts = $processed.Split([Environment]::NewLine) | Where-Object { $_ -ne '' }

foreach ($command in $parts) {
    Write-Host "执行中..."
    Write-Host $command
    Write-Host ""
    
    try {
        $resp = & $command
        Write-Host "响应内容:"
        Write-Host $resp
    }
    catch {
        Write-Host "执行错误: $_"
    }
    
    Write-Host "----------------------------------------"
    Start-Sleep -Seconds 2
}
