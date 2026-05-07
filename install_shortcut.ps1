$scriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent
$exePath = Join-Path $scriptDir "DesktopClock.exe"
$distPath = Join-Path $scriptDir "dist\DesktopClock.exe"

if (-not (Test-Path $exePath)) {
    if (Test-Path $distPath) { $exePath = $distPath }
    else {
        Write-Host "未找到 DesktopClock.exe，请先运行 build_exe.bat" -ForegroundColor Red
        Read-Host "按 Enter 退出"
        exit 1
    }
}

$shell = New-Object -ComObject WScript.Shell

function New-Shortcut {
    param([string]$LinkPath, [string]$TargetPath, [string]$WorkingDir, [string]$Label)
    if (Test-Path $LinkPath) {
        $ans = Read-Host "$Label 快捷方式已存在，覆盖? (y/N)"
        if ($ans -ne 'y' -and $ans -ne 'Y') { Write-Host "跳过: $LinkPath"; return }
    }
    $s = $shell.CreateShortcut($LinkPath)
    $s.TargetPath       = $TargetPath
    $s.WorkingDirectory = $WorkingDir
    $s.Description      = "桌面时钟"
    $s.IconLocation     = "$TargetPath,0"
    $s.Save()
    Write-Host "已创建: $LinkPath" -ForegroundColor Green
}

$startMenu = Join-Path ([Environment]::GetFolderPath('StartMenu')) "Programs"
New-Shortcut (Join-Path $startMenu "DesktopClock.lnk") $exePath (Split-Path $exePath -Parent) "开始菜单"
New-Shortcut (Join-Path ([Environment]::GetFolderPath('Desktop')) "DesktopClock.lnk") $exePath (Split-Path $exePath -Parent) "桌面"

Write-Host "完成！右键 DesktopClock → 固定到开始屏幕" -ForegroundColor Green
Read-Host "按 Enter 退出"
