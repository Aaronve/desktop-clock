"""
桌面时钟应用程序 — Desktop Clock
====================================
一个无边框、半透明、置顶显示的桌面时钟。
基于 Python 标准库 tkinter 实现，无需额外依赖。

运行方式（不显示控制台窗口）：
    pythonw main.py
"""

import tkinter as tk
from datetime import datetime

# ------------------------------------------------------------
# 星期映射（中文显示）
# ------------------------------------------------------------
WEEKDAYS = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"]

# ------------------------------------------------------------
# 外观配置
# ------------------------------------------------------------
BG_COLOR = "#0d0d0d"       # 深黑背景（配合透明度实现半透明深色效果）
FG_COLOR = "#f0f0f0"       # 浅白文字
TIME_FONT = ("Consolas", 48, "bold")
DATE_FONT = ("Microsoft YaHei", 16)
WIN_ALPHA = 0.82           # 窗口透明度（0.0 全透明 ~ 1.0 不透明）
WIN_MARGIN = 700            # 距屏幕边缘的像素


class DesktopClock:
    """桌面时钟主类，封装窗口创建、事件绑定与时间刷新逻辑。"""

    def __init__(self):
        self.root = tk.Tk()
        self.root.title("桌面时钟")

        # ---- 窗口属性 ----
        self.root.overrideredirect(True)          # 隐藏标题栏与边框
        self.root.attributes("-topmost", True)    # 始终置顶
        self.root.attributes("-alpha", WIN_ALPHA) # 半透明
        self.root.configure(bg=BG_COLOR)

        # ---- 界面元素 ----
        self._build_ui()

        # ---- 拖拽相关 ----
        self._drag_x = 0
        self._drag_y = 0
        self.root.bind("<Button-1>", self._on_press)
        self.root.bind("<B1-Motion>", self._on_drag)

        # ---- 右键菜单 ----
        self._build_context_menu()

        # ---- 定位到右下角 ----
        self._snap_to_corner()

        # ---- 启动时间刷新 ----
        self._tick()

    def _build_ui(self):
        """创建时间与日期标签。"""
        self.lbl_time = tk.Label(
            self.root, font=TIME_FONT, fg=FG_COLOR, bg=BG_COLOR,
        )
        self.lbl_time.pack(padx=24, pady=(18, 0))

        self.lbl_date = tk.Label(
            self.root, font=DATE_FONT, fg=FG_COLOR, bg=BG_COLOR,
        )
        self.lbl_date.pack(padx=24, pady=(0, 14))

    def _build_context_menu(self):
        """右键弹出菜单：仅包含「退出」。"""
        self._menu = tk.Menu(self.root, tearoff=0)
        self._menu.add_command(label="退出", command=self._exit)
        self.root.bind("<Button-3>", self._show_menu)

    def _snap_to_corner(self):
        """将窗口置于屏幕右下角，距底边和右边各 WIN_MARGIN 像素。"""
        self.root.update_idletasks()
        w = self.root.winfo_reqwidth()
        h = self.root.winfo_reqheight()
        sw = self.root.winfo_screenwidth()
        sh = self.root.winfo_screenheight()
        x = sw - w - WIN_MARGIN
        y = sh - h - WIN_MARGIN
        self.root.geometry(f"+{x}+{y}")

    def _on_press(self, event):
        """记录鼠标按下时的相对偏移。"""
        self._drag_x = event.x
        self._drag_y = event.y

    def _on_drag(self, event):
        """根据鼠标移动量更新窗口位置。"""
        nx = self.root.winfo_x() + event.x - self._drag_x
        ny = self.root.winfo_y() + event.y - self._drag_y
        self.root.geometry(f"+{nx}+{ny}")

    def _show_menu(self, event):
        """在鼠标位置弹出右键菜单。"""
        try:
            self._menu.tk_popup(event.x_root, event.y_root)
        finally:
            self._menu.grab_release()

    def _tick(self):
        """每秒更新一次时间与日期显示。"""
        now = datetime.now()
        self.lbl_time.config(text=now.strftime("%H:%M:%S"))
        self.lbl_date.config(text=now.strftime(f"%Y年%m月%d日  {WEEKDAYS[now.weekday()]}"))
        self.root.after(1000, self._tick)

    def _exit(self):
        """安全退出程序。"""
        self.root.quit()
        self.root.destroy()

    def run(self):
        """启动主事件循环。"""
        try:
            self.root.mainloop()
        except KeyboardInterrupt:
            self._exit()


# 入口
if __name__ == "__main__":
    try:
        DesktopClock().run()
    except Exception as exc:
        # 异常兜底：写入 stderr 以便排查
        import sys
        print(f"[DesktopClock] 启动失败: {exc}", file=sys.stderr)
        sys.exit(1)
