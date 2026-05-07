============================================
  桌面时钟 — 打包 & 开始菜单固定指南
============================================

[前置要求]
  - Python 3.10+（已安装）
  - pip 可用
  - Windows 10 或 Windows 11

============================================
  第一步：打包为 EXE
============================================

  方法一（推荐）：双击运行
    在文件资源管理器中打开 D:\DesktopClock\
    双击 build_exe.bat，等待打包完成

  方法二：命令行执行
    cd D:\DesktopClock
    build_exe.bat

  脚本会自动：
    1. 检查 Python 是否可用
    2. 安装 PyInstaller（如果尚未安装）
    3. 执行打包：--onefile --windowed --name DesktopClock
    4. 清理临时 build 文件夹和 .spec 文件
    5. 生成 dist\DesktopClock.exe

  打包参数说明：
    --onefile       → 打包为单个 EXE 文件
    --windowed      → 不显示控制台窗口（GUI 模式）
    --name          → 输出文件名
    --clean         → 打包前清理 PyInstaller 缓存

============================================
  第二步：创建快捷方式
============================================

  在 PowerShell 中运行 install_shortcut.ps1：

    方法一：
      右键 install_shortcut.ps1 →「使用 PowerShell 运行」

    方法二：
      打开 PowerShell → 执行：
      cd D:\DesktopClock
      Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
      .\install_shortcut.ps1

  脚本会在「开始菜单\程序」和「桌面」各创建一个快捷方式。

============================================
  第三步：固定到开始屏幕（手动）
============================================

  Windows 10：
    1. 按 Win 键 → 在应用列表中找到 "DesktopClock"
    2. 右键 →「固定到开始屏幕」

  Windows 11：
    1. 按 Win 键 →「所有应用」→ 找到 "DesktopClock"
    2. 右键 →「固定到开始屏幕」

  * 注意：Windows 不提供命令行方式直接"固定到开始屏幕"，
    必须由用户手动操作一次。此快捷方式将永久保留在开始菜单中。

============================================
  设置开机自启（可选）
============================================

  如果希望时钟随系统启动自动运行：

  1. 按 Win+R → 输入 shell:startup → 回车
  2. 将 DesktopClock.exe 的快捷方式复制到打开的文件夹中
  3. 或复制以下快捷方式：
     %AppData%\Microsoft\Windows\Start Menu\Programs\DesktopClock.lnk

============================================
  文件清单
============================================

  build_exe.bat              打包脚本（双击运行）
  install_shortcut.ps1       PowerShell 快捷方式安装脚本
  README_exe.txt             本说明文件
  main.py                    源代码
  dist\DesktopClock.exe      打包输出（运行 build_exe.bat 后生成）
