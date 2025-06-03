$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path -Parent $scriptPath

$filePath = Join-Path -Path $scriptDir -ChildPath "requests_ps.txt"

if (-not (Test-Path $filePath)) {
    Write-Host "requests_ps.txt 文件不存在: $filePath"
    exit 1
}

$content = Get-Content -Path $filePath -Raw

$commands = $content -split '&&'

foreach ($cmd_block in $commands) {

    $trimmed = $cmd_block.Trim()

    if ([string]::IsNullOrWhiteSpace($trimmed)) {
        continue
    }

    # 合并换行并去除反斜杠转义
    #$command = $trimmed -replace '\\\s+', ' ' -replace '\s+', ' '

    Write-Host "执行中..."
    Write-Host "$trimmed"
    Write-Host ""

    try {
        $resp = Invoke-Expression $trimmed
    } catch {
        $resp = "错误: $_"
    }
    $t = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "响应内容:"
    Write-Host "$resp"
    Write-Host ""
    Write-Output $t
    Write-Host "----------------------------------------"
    Start-Sleep -Seconds 2
}