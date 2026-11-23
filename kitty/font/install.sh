#!/usr/bin/env bash
#
# 安装 kitty 配置所需的字体
#
# 字体文件本身不入库（约 54MB），这里负责「用包管理器装出来」：
#   macOS  -> brew install --cask（已装则跳过）
#   Linux  -> 打印手动安装步骤（发行版差异大，不硬编码下载地址）
#
# 用法：
#   ./install.sh            安装缺失的字体
#   ./install.sh --check    只检查，不安装（退出码：0=齐全，1=有缺失）
#   ./install.sh --dry-run  显示会执行什么，不实际安装
#
set -euo pipefail

# cask 名:字体文件名前缀（用字体是否落地来判断，而不是 brew 是否记录过安装——
# 手动复制到 ~/Library/Fonts 的字体同样算「已装」）
PAIRS=(
  "font-victor-mono-nerd-font:VictorMono"
  "font-lxgw-wenkai:LXGWWenKai"
  "font-maple-mono-nf-cn:MapleMono"
)

MODE="install"
for arg in "$@"; do
  case "$arg" in
    --check)   MODE="check" ;;
    --dry-run) MODE="dry-run" ;;
    -h|--help) sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "未知参数: $arg（--check / --dry-run / --help）" >&2; exit 2 ;;
  esac
done

have() {
  # 字体是否已落到用户字体目录（按文件名前缀判断，够用且不依赖系统命令）
  ls "$HOME/Library/Fonts" 2>/dev/null | grep -qiE "$1"
}

report_state() {
  local ok=0
  for pair in "VictorMono:Victor Mono" "LXGWWenKai:LXGW WenKai" "MapleMono:Maple Mono NF"; do
    prefix="${pair%%:*}"; label="${pair#*:}"
    if have "$prefix"; then
      printf 'ok    %s\n' "$label"
    else
      printf 'MISS  %s\n' "$label"
      ok=1
    fi
  done
  return $ok
}

case "$(uname -s)" in
  Darwin)
    if ! command -v brew >/dev/null 2>&1; then
      cat <<'EOF'
未检测到 Homebrew。请手动安装以下字体后重跑 --check：
  Victor Mono Nerd Font  https://github.com/ryanoasis/nerd-fonts/releases  (VictorMono.zip)
  霞鹜文楷 LXGW WenKai    https://github.com/lxgw/LxgwWenKai/releases
  Maple Mono NF CN        https://github.com/subframe7536/maple-font/releases
安装方式：双击 .ttf，或拖进「字体册」，或复制到 ~/Library/Fonts
EOF
      exit 1
    fi

    case "$MODE" in
      check)
        report_state && { echo "字体齐全"; exit 0; } || { echo "有缺失字体"; exit 1; }
        ;;
      dry-run)
        for pair in "${PAIRS[@]}"; do
          c="${pair%%:*}"; prefix="${pair#*:}"
          if have "$prefix"; then
            printf 'skip  brew install --cask %s（字体已在 ~/Library/Fonts）\n' "$c"
          else
            printf 'run   brew install --cask %s\n' "$c"
          fi
        done
        ;;
      install)
        missing=()
        for pair in "${PAIRS[@]}"; do
          c="${pair%%:*}"; prefix="${pair#*:}"
          have "$prefix" || missing+=("$c")
        done
        if [ ${#missing[@]} -eq 0 ]; then
          echo "所需字体均已存在，无需操作"
        else
          echo "安装缺失的 cask: ${missing[*]}"
          brew install --cask "${missing[@]}"
        fi
        echo
        report_state || { echo "字体目录里仍有缺失，请重开终端后重跑 --check" >&2; exit 1; }
        echo
        echo "提示：完全退出 kitty（Cmd+Q）再重开才能生效。"
        ;;
    esac
    ;;

  Linux)
    cat <<'EOF'
Linux 需要手动安装（各发行版包名不同）：
  1) 下载：
     Victor Mono Nerd Font  https://github.com/ryanoasis/nerd-fonts/releases  (VictorMono.zip)
     霞鹜文楷 LXGW WenKai    https://github.com/lxgw/LxgwWenKai/releases
     Maple Mono NF CN        https://github.com/subframe7536/maple-font/releases
  2) 解压后放入用户字体目录并刷新缓存：
       mkdir -p ~/.local/share/fonts
       cp *.ttf ~/.local/share/fonts/
       fc-cache -f
  3) 验证：
       fc-list | grep -i -e VictorMono -e LXGW -e Maple
EOF
    exit 0
    ;;

  *)
    echo "不支持的系统: $(uname -s)" >&2
    exit 1
    ;;
esac
