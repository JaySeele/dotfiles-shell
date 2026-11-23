---
tags:
  - Computer
  - terminal tool
type: config
date: 2026-11-12
updated: 2026-11-24
---

# kitty 字体

`kitty-font.conf` 需要的字体**不随仓库分发**（总计约 54 MB，已由 `.gitignore` 排除）。本目录只保留字体清单、来源与安装方式。

---

## 字体清单

| 字体族 | 用途 | 对应配置项 |
|------|----------|--------|
| VictorMono Nerd Font Mono Light | 主字体 | `font_family` |
| VictorMono Nerd Font Mono SemiBold | 粗体 | `bold_font` |
| VictorMono Nerd Font Mono Light Italic | 斜体 | `italic_font` |
| VictorMono Nerd Font Mono SemiBold Italic | 粗斜体 | `bold_italic_font` |
| LXGW WenKai Regular（霞鹜文楷） | 中文 | `symbol_map` U+4E00–U+9FCB |
| Maple Mono NF CN | 图标 / 私用区 | `symbol_map` U+E000–U+F8FF、U+F0000–U+FFFFD |

`kitty-font.conf` 里的对应片段：

```conf
font_size                                    20
font_family                                  VictorMono Nerd Font Mono Light
bold_font                                    VictorMono Nerd Font Mono SemiBold
italic_font                                  VictorMono Nerd Font Mono Light Italic
bold_italic_font                             VictorMono Nerd Font Mono SemiBold Italic
symbol_map                                   U+4E00-U+9fA5,U+9FA6-U+9FCB       LXGW WenKai Regular
symbol_map                                   U+E000-U+E09F,U+E0D8-U+F8FF       Maple Mono NF CN
symbol_map                                   U+F0000-U+FFFFD                   Maple Mono NF CN
```

> [!note] 为什么用「Nerd Font Mono」版本
> 等宽版把图标字符宽度对齐到单字符格，kitty 里状态栏、`eza --icons`、`starship` 提示符才不会错位。

---

## 安装

### macOS（推荐：脚本）

```bash
./install.sh              # 安装缺失的字体（已装的自动跳过，可重复执行）
./install.sh --check      # 只检查，缺字体时退出码为 1
./install.sh --dry-run    # 只显示会执行什么
```

脚本不依赖仓库里的 ttf：它用 Homebrew cask 安装，并按「字体是否已落到 `~/Library/Fonts`」判断是否已装，所以手动复制进去的字体同样会被认作已装。

### macOS（手动 brew 一行）

```bash
brew install --cask font-victor-mono-nerd-font font-lxgw-wenkai font-maple-mono-nf-cn
```

### macOS（手动下载）

| 字体 | 下载地址 |
|------|----------|
| Victor Mono Nerd Font | <https://github.com/ryanoasis/nerd-fonts/releases>（`VictorMono.zip`） |
| 霞鹜文楷 LXGW WenKai | <https://github.com/lxgw/LxgwWenKai/releases> |
| Maple Mono NF CN | <https://github.com/subframe7536/maple-font/releases> |

下载后双击安装，或把 `.ttf` 拖进「字体册」，也可直接复制到 `~/Library/Fonts`。

### Linux（Debian）

`./install.sh` 在 Linux 上会打印手动步骤（各发行版包名不同，不硬编码下载地址）：

```bash
mkdir -p ~/.local/share/fonts
# 把 ttf 放进该目录后
fc-cache -f
```

> [!tip] 装完 kitty 还是旧字体？
> macOS 上先完全退出 kitty（Cmd+Q，不是关窗口）再重开。仍然不对就执行 `atsutil databases -removeUser` 清掉用户字体缓存。

---

## 验证

```bash
# macOS / Linux 通用
kitty +list-fonts | grep -i -e 'Victor Mono' -e 'LXGW' -e 'Maple'

# Linux
fc-list | grep -i -e VictorMono -e LXGW -e Maple
```

---

## 备选字体（未安装）

`kitty-font.conf` 里被注释掉的可选配置，需要时自行安装：

| 字体 | 配置项 | 获取方式 |
|------|--------|----------|
| Fira Code Regular / Medium | `font_family` / `bold_font` | `brew install --cask font-fira-code` |
| VictorMono Nerd Font Mono Thin / Bold Italic | `italic_font` / `bold_italic_font` | `brew install --cask font-victor-mono-nerd-font` |
| JetBrainsMono Nerd Font Mono Thin / Bold Italic | `italic_font` / `bold_italic_font` | `brew install --cask font-jetbrains-mono-nerd-font` |

---

## 为什么不入库

> [!warning] 体积
> LXGW 24 MB + Maple 20 MB + Victor Mono 四个字重约 9.8 MB，合计约 54 MB。git 每次提交都会保留一份 blob，仓库会永久膨胀且 clone 变慢。字体属于「运行环境依赖」而非「配置」，用 brew / 下载脚本复现更合适。
>
> 历史版本里曾把字体提交进旧仓库（kitty 单独一个仓），合并进 `dotfiles-shell` 时已在 `git filter-repo` 阶段整体剔除，新仓历史中不含这些字体。

---

## 许可证

- Victor Mono — SIL Open Font License 1.1
- LXGW WenKai 霞鹜文楷 — SIL Open Font License 1.1（派生自 Klee One）
- Maple Mono — SIL Open Font License 1.1

三者均允许随项目一起分发，这里只是出于仓库体积考虑不入库。
