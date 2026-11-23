# dotfiles-shell

zsh · starship · kitty · fastfetch · lazygit

## 安装 / 重建软链

```bash
~/dotfiles/shell/install.sh
```

幂等：已存在的软链打印 `ok`，目标位置是真目录则打印 `skip`（不会覆盖）。

## 撤销

```bash
rm ~/.config/{zsh,starship,kitty,fastfetch,lazygit}   # 只删链，不删目标
```

## 说明

- 本目录每个子目录 = `~/.config/<同名>` 的软链目标
- 字体不入库，装法见 `kitty/font/README.md`（`kitty/font/install.sh` 一条命令）
- 换机：clone → 跑 `install.sh` → 复制 `secrets.zsh` → 装字体
