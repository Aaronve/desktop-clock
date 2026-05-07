# Desktop Clock 桌面时钟

无边框、半透明、置顶显示的桌面时钟，基于 Python 标准库 tkinter，无需额外依赖。

## 运行

```bash
pythonw main.py        # 推荐 — 无控制台窗口
python main.py         # 会弹出控制台窗口
```

## 功能

- 实时显示时间 HH:MM:SS，每秒刷新
- 显示日期（年月日 + 星期）
- 无边框、置顶显示，半透明深色背景
- 按住任意位置可拖拽移动
- 右键菜单：切换置顶 / 退出
- 默认位于屏幕右下角

## 自定义

编辑 `main.py` 顶部配置常量：

| 常量 | 说明 |
|------|------|
| `BG_COLOR` | 背景颜色 |
| `FG_COLOR` | 文字颜色 |
| `TIME_FONT` | 时间字体 |
| `DATE_FONT` | 日期字体 |
| `WIN_ALPHA` | 窗口透明度 (0.0~1.0) |
| `WIN_MARGIN` | 距屏幕边缘距离（像素） |

## 打包为 EXE

```bash
build_exe.bat          # 需要 Python + PyInstaller
```

输出：`dist\DesktopClock.exe`

## 创建快捷方式

打包完成后，在 PowerShell 中运行：

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\install_shortcut.ps1
```

会在开始菜单和桌面各创建一个快捷方式。之后可手动右键 → 固定到开始屏幕。

## 开机自启

按 `Win+R` → 输入 `shell:startup` → 将快捷方式复制到该文件夹。
