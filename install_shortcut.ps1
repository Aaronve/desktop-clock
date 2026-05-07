#Requires -Version 5.0

<#
.SYNOPSIS
    为 DesktopClock.exe 创建「开始菜单」和「桌面」快捷方式。
.DESCRIPTION
    运行前请先执行 build_exe.bat 完成打包。
    无需管理员权限。
#>

$exePath = "D:\DesktopClock\DesktopClock.exe"
if (-not (Test-Path $exePath)) {
    $exePath = "D:\DesktopClock\dist\DesktopClock.exe"
    if (-not (Test-Path $exePath)) {
        Write-Host "错误: 未找到 DesktopClock.exe，请先运行 build_exe.bat" -ForegroundColor Red
        Read-Host "按 Enter 退出"
        exit 1
    }
}

$shell = New-Object -ComObject WScript.Shell
$workingDir = Split-Path $exePath -Parent

function New-Shortcut {
    param(
        [string]$LinkPath,
        [string]$TargetPath,
        [string]$WorkingDirectory,
        [string]$Label
    )

    if (Test-Path $LinkPath) {
        $ans = Read-Host "$Label 快捷方式已存在，是否覆盖? (y/N)"
        if ($ans -ne 'y' -and $ans -ne 'Y') {
            Write-Host "跳过: $LinkPath"
            return
        }
    }

    $shortcut = $shell.CreateShortcut($LinkPath)
    $shortcut.TargetPath       = $TargetPath
    $shortcut.WorkingDirectory = $WorkingDirectory
    $shortcut.Description      = "桌面时钟"
    $shortcut.IconLocation     = "$TargetPath,0"
    $shortcut.Save()

    Write-Host "已创建: $LinkPath" -ForegroundColor Green
}

# 开始菜单
$startMenuFolder = [Environment]::GetFolderPath('StartMenu') + "\Programs"
New-Shortcut -LinkPath (Join-Path $startMenuFolder "DesktopClock.lnk") `
             -TargetPath $exePath `
             -WorkingDirectory $workingDir `
             -Label "开始菜单"

# 桌面
$desktopFolder = [Environment]::GetFolderPath('Desktop')
New-Shortcut -LinkPath (Join-Path $desktopFolder "DesktopClock.lnk") `
             -TargetPath $exePath `
             -WorkingDirectory $workingDir `
             -Label "桌面"

Write-Host "`n完成！现在可以打开开始菜单，找到 DesktopClock，右键 -> 固定到开始屏幕/开始菜单。" -ForegroundColor Green
Read-Host "按 Enter 退出"
