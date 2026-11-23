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
if [ -d "$repo_dir/kitty" ] && [ ! -d "$repo_dir/kitty/font" ]; then
  printf 'warn  kitty/font 缺失，请把字体复制到 %s/kitty/font\n' "$repo_dir"
fi
