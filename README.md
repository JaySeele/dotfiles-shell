# dotfiles-shell

zsh · starship · kitty · fastfetch · lazygit

## 安装 / 重建软链（GNU stow）

```bash
brew install stow      # macOS；Debian 用 apt install stow
stow -d ~/dotfiles -t ~/.config shell
```

幂等：重复执行安全；已存在的正确软链不会被改动。

## 撤销

```bash
stow -D -d ~/dotfiles -t ~/.config shell
```

## 说明

- 本目录里的每个子目录 = `~/.config/<同名>` 的软链目标
- 修改文件后在本仓库提交、push 即可
- 字体等大文件不入库，见 `kitty/font/README.md`

> **注意**：`.stow-local-ignore` 会**替换** stow 的默认忽略列表（不是追加）。所以必须显式列出 `^/\.git$`、`^/\.gitignore$`，否则 stow 会把它们也链到 `~/.config` 里。
