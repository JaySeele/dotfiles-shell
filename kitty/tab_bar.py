#!/usr/bin/env python3
# License: GPLv3

import re

from kitty.fast_data_types import wcswidth
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb

try:
    from kitty.tab_bar import apply_title_template, draw_attributed_string
except ImportError:
    apply_title_template = None
    draw_attributed_string = None
try:
    from kitty.tab_bar import truncate_line
except ImportError:
    truncate_line = None


def _c(value: "str | int") -> int:
    """接受 "#RGB" / "#RRGGBB" / 0xRRGGBB，转成 Screen 认的颜色。"""
    if isinstance(value, int):
        return as_rgb(value)
    h = str(value).strip().lstrip("#")
    if len(h) == 3:
        h = "".join(ch * 2 for ch in h)
    if len(h) != 6:
        raise ValueError(f"bad colour: {value!r}")
    return as_rgb(int(h, 16))


# 半透明窗口：这些色值如果出现在 kitty.conf 的 transparent_background_colors 里，
# 对应的胶囊背景才会跟随 background_opacity（改色时两边要一起改，改完重启 kitty）。
CRUST = "#11111B"
BASE = "#1E1E2E"
SURFACE0 = "#313244"
OVERLAY0 = "#6C7086"
SUBTEXT0 = "#A6ADC8"
MAUVE = "#98F5FF"
YELLOW = "#F9E2AF"
PEACH = "#FAB387"

BAR_BG = 0  # 0 = 用终端默认背景，天然跟随 background_opacity
ACTIVE_BG, ACTIVE_FG, ACTIVE_DIM = _c(MAUVE), _c(CRUST), _c(BASE)
IDLE_BG, IDLE_FG, IDLE_DIM = _c(SURFACE0), _c(SUBTEXT0), _c(OVERLAY0)
DOT_ATTENTION, DOT_ACTIVITY = _c(PEACH), _c(YELLOW)

CAP_LEFT, CAP_RIGHT = "\ue0b6", "\ue0b4"
GAP = " "
DOT = "\u25cf"

SGR_RE = re.compile(r"\x1b\[[0-9;]*m")


def _w(text: str) -> int:
    """Display width in cells, ignoring SGR escapes."""
    return wcswidth(SGR_RE.sub("", text))


def draw_tab(
    draw_data: DrawData,
    screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:

    if draw_data.tab_bar_edge in ("left", "right"):
        from kitty.tab_bar import draw_tab_with_powerline

        return draw_tab_with_powerline(
            draw_data, screen, tab, before, max_tab_length, index, is_last, extra_data
        )

    active = tab.is_active
    bg, fg, dim = (
        (ACTIVE_BG, ACTIVE_FG, ACTIVE_DIM) if active else (IDLE_BG, IDLE_FG, IDLE_DIM)
    )

    budget = max_tab_length - (0 if is_last else 1)
    screen.cursor.bg = BAR_BG
    screen.cursor.fg = BAR_BG

    idx = str(index)
    if tab.needs_attention:
        dot, dot_fg = DOT, (ACTIVE_FG if active else DOT_ATTENTION)
    elif tab.has_activity_since_last_focus:
        dot, dot_fg = DOT, (ACTIVE_FG if active else DOT_ACTIVITY)
    else:
        dot, dot_fg = "", 0

    overhead = 2 + 1 + _w(idx) + 1 + 1 + (2 if dot else 0)
    title_budget = max(0, budget - overhead)

    title = tab.title or ""
    if apply_title_template is not None:
        try:
            title = apply_title_template(draw_data, tab, index, title_budget)
        except Exception:
            title = tab.title or ""
    if title_budget < 1:
        title = ""
    elif _w(title) > title_budget:
        if truncate_line is not None:
            try:
                title = truncate_line(title, title_budget)
            except Exception:
                title = title[:title_budget]
        else:
            title = title[:title_budget]

    screen.cursor.fg = bg
    screen.cursor.bg = BAR_BG
    screen.draw(CAP_LEFT)

    screen.cursor.bg = bg
    screen.cursor.fg = dim
    screen.draw(GAP + idx)
    screen.cursor.fg = fg
    screen.draw(GAP)
    if title:
        if draw_attributed_string is not None:
            draw_attributed_string(title, screen)
        else:
            screen.draw(title)
    if dot:
        screen.cursor.fg = dot_fg
        screen.draw(GAP + dot)
    screen.cursor.bg = bg
    screen.cursor.fg = bg
    screen.draw(GAP)

    screen.cursor.bg = BAR_BG
    screen.draw(CAP_RIGHT)
    if not is_last:
        screen.cursor.fg = BAR_BG
        screen.draw(GAP)
    return screen.cursor.x
