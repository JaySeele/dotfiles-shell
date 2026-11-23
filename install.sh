#!/bin/sh
# 把本仓库里的应用目录软链到 ~/.config（幂等，重复运行安全）
set -eu
repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
for src in "$repo_dir"/*/; do
  app=$(basename "$src")
  [ -d "$src" ] || continue
  link="$HOME/.config/$app"
  if [ -L "$link" ]; then
    printf 'ok    %s -> %s\n' "$link" "$(readlink "$link")"
  elif [ -e "$link" ]; then
    printf 'skip  %s 已存在且不是软链，跳过\n' "$link"
  else
    ln -s "$src" "$link"
    printf 'link  %s -> %s\n' "$link" "$src"
  fi
done
if [ -d "$repo_dir/kitty" ] && ! ls "$repo_dir"/kitty/font/*.ttf >/dev/null 2>&1; then
  printf 'note  字体不入库，按 %s/kitty/font/README.md 安装所需字体\n' "$repo_dir"
fi
