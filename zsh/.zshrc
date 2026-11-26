# ------------------------------
# oh-my-zsh
# ------------------------------

export ZSH="/Users/soc/.oh-my-zsh"
ZSH_THEME=""
zstyle ':omz:update' mode disabled

plugins=(
    zsh-autosuggestions
    zsh-syntax-highlighting
)

fpath=($ZDOTDIR/completions $fpath)

source $ZSH/oh-my-zsh.sh

# vi mode
# bindkey -v
# setopt nobeep

# starship
eval "$(starship init zsh)"

# ------------------------------
# PATH
# ------------------------------

# dsh
export PATH="$HOME/.dsh/bin:$PATH"

# homebrew
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"

# java
export JAVA_HOME="/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"

# npm
export PATH="$HOME/.npm-global/bin:$PATH"

# nvim
export EDITOR="/opt/homebrew/bin/nvim"

# obsidian
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"

# script
export PATH="$PATH:$HOME/script"

# python / pipx
export PATH="/opt/homebrew/opt/python@3.12/libexec/bin:$PATH"
export PATH="$PATH:$HOME/.local/bin"
export PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:${PATH}"

# sqlmap
export SQLMAP_OUTPUT="/Users/soc/Documents/Sqlmap/output"

# ------------------------------
# Environment
# ------------------------------

# clash proxy (仅在代理处于活动状态时设置，否则curl会超时挂起)
if lsof -i :7897 -sTCP:LISTEN -t >/dev/null 2>&1; then
    export https_proxy=http://127.0.0.1:7897
    export http_proxy=http://127.0.0.1:7897
    export all_proxy=socks5://127.0.0.1:7897
    # 大写形式（原 .zprofile 无条件设置，合并后改为仅在代理活动时生效）
    export HTTPS_PROXY=http://127.0.0.1:7897
    export HTTP_PROXY=http://127.0.0.1:7897
fi

# Fix terminal type for TUI apps；但保留 kitty 的 xterm-kitty（否则 yazi 认不出 Kitty 图形协议，图片预览变马赛克）
[[ $TERM != xterm-kitty ]] && export TERM=xterm-256color

# Homebrew - USTC mirror
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_CASK_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-cask.git"
export HOMEBREW_PIP_INDEX_URL="https://mirrors.ustc.edu.cn/pypi/web/simple"

# ollama (Debian 远程模型服务)
export OLLAMA_HOST="100.67.58.98:11434"

# XDG / config directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export PUB_CACHE="$HOME/.local/share/pub-cache"

# API keys（敏感，存于 secrets.zsh，被 .gitignore 排除，不入库）
if [[ -f "$ZDOTDIR/secrets.zsh" ]]; then
    source "$ZDOTDIR/secrets.zsh"
fi

# ------------------------------
# Tool Initialization
# ------------------------------

# cargo（补 --bin 后的 bin 名：官方补全没写这一项，这里从 src/bin/*.rs 取）
_cargo_complete() {
    local -a bins
    bins=(src/bin/*.rs(N:t:r))
    if (( $#bins )); then
        if [[ ${words[CURRENT-1]} == --bin ]]; then
            compadd -a bins
            return
        elif [[ ${words[CURRENT]} == --bin=* ]]; then
            compset -P '--bin='
            compadd -a bins
            return
        fi
    fi
    _cargo
}
compdef _cargo_complete cargo

# fzf
source <(fzf --zsh)

# lazygit
# (no init needed, just alias)

# nvm (lazy load — 延迟加载，首次使用 node/npm/nvm 时才初始化)
export NVM_DIR="$HOME/.nvm"
lazy_load_nvm() {
    unset -f nvm node npm npx yarn pnpm corepack 2>/dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
for cmd in nvm node npm npx yarn pnpm corepack; do
    eval "$cmd() { lazy_load_nvm; $cmd \"\$@\" }"
done

# zoxide
eval "$(zoxide init zsh)"

# ------------------------------
# Aliases
# ------------------------------

# --- system ---
alias a='yazi'
alias c='clear'
alias ch='rr ~/.thumbnails ~/.adobe ~/.ntfstool ~/.playwright-* ~/.dart-tool ~/.immich-photos-sync.log ~/.zsh-defer ~/Temp ~/.zcompdump* 2>/dev/null; echo "✅ 已清理无用缓存"'
alias cls='clear'
alias cp='cp -r'
alias cz='cat ~/.config/zsh/.zshrc'
alias e='exit'
alias f='fzf'
alias fa='clear && LC_TIME=en_US.UTF-8 fastfetch'
alias ff='echo "ffmpeg" && ffmpeg'
alias la='eza -la --icons --group-directories-first'
alias ll='eza -lAh --icons --group-directories-first | sed "s/^/   /"'
alias ls='eza -x --icons --group-directories-first'
alias lt='eza --tree --icons'
alias m1='mv ~/Downloads/*.mp4 /Users/soc/Applications/.1/vedios'
alias nv='nvim'
alias nvz='nvim ~/.config/zsh/.zshrc'
alias op='open .'
alias re='sudo reboot'
alias rr='rm -rf'
alias rra='rm -rf *'
alias rrd='find . -name ".DS_Store" -type f -delete'
alias rrg='rm -rf .git'
alias s='sudo !!'
alias souz='clear && source ~/.config/zsh/.zshrc'
alias sql='echo "sqlmap --batch" && unset all_proxy HTTP_PROXY http_proxy HTTPS_PROXY https_proxy && sqlmap --batch'
alias targz='tar xzvf'
alias te='tree'
alias xf='sudo xattr -rd com.apple.quarantine '
alias zc='cd ~/.config'
alias zg='cd ~/Git'
alias zk='cd ~/.config/kitty/'
alias zm='cd /tmp'
alias zs='cd /Users/soc/Library/Application\ Support/'
alias zu='cd /Users/soc/Documents/Ukulele/个人曲谱'
alias zz='z -'
alias z1='cd /Users/soc/Applications/.1'

# --- aibalance ---
alias aibre='echo "xcodebuild AIBalanceApp (Release)" && cd /Users/soc/Documents/ClaudeDevelopment/AIBalanceApp/AIBalanceApp_macOS_v1.0.2 && killall AIBalanceApp 2>/dev/null; xcodebuild -scheme AIBalanceApp -configuration Release -destination "platform=macOS" -derivedDataPath /tmp/aibuild build && rm -rf /Applications/AIBalanceApp.app && ditto /tmp/aibuild/Build/Products/Release/AIBalanceApp.app /Applications/AIBalanceApp.app && open /Applications/AIBalanceApp.app'

# --- git ---
alias ga='git status'
alias gc='git clone'
alias gl='git log'
alias gpush='git push -u gitee main && git push -u github main'
alias gr='git remote -v'

# --- homebrew ---
alias ba='echo "brew update && brew upgrade && brew cleanup" && brewba'
alias bc='echo "bc is disabled. Use \bc if you really need it."'
alias cb='brew cleanup -s && rm -rf ~/Library/Caches/Homebrew/*'

# --- kitty ---
alias icat='echo "kitty +kitten icat" && kitty +kitten icat'
alias nvk='nvim ~/.config/kitty/kitty.conf'
alias souk='clear && kitten @ load-config'
alias ssh='kitty +kitten ssh'

# --- lazygit ---
alias lg='lazygit'

# --- lua ---
alias lj='echo "luajit" && luajit'
alias lu='echo "lua" && lua'

# --- ollama ---
alias br='echo "ssh debian: ~/ollama/daily-brief.sh" && ssh -p 2222 soc@100.67.58.98 "~/ollama/daily-brief.sh"'
alias o14='echo "ollama run qwen3:14b" && ollama run qwen3:14b'
alias o8='echo "ollama run qwen3:8b" && ollama run qwen3:8b'
alias ols='ollama list'
alias omc='echo "ssh debian: ollama/mchat.py" && ssh -p 2222 -t soc@100.67.58.98 /home/soc/ollama/.venv/bin/python /home/soc/ollama/mchat.py'
alias ops='ollama ps'

# --- python ---
alias pyrun='echo "uv run python" && uv run python'
alias soud='echo "deactivate" && deactivate'
alias soup='echo "source ./.venv/bin/activate" && source ./.venv/bin/activate'

# --- rsync (sync) ---
alias imgo="echo \"immich-go upload\" && immich-go upload from-folder -s http://100.67.58.98:2283 -k \$IMMICH_API_KEY --manage-heic-jpeg StackCoverHEIC $HOME/Pictures/Photos Library.photoslibrary"
alias musicsyn="echo \"rsync musicn\" && rsync -avz -e \"ssh -p 2222\" soc@100.67.58.98:~/docker/musicn/data/ ~/Music/musicn/"

# --- rust ---
alias cn='echo "cargo new" && cargo new'
alias cr='echo "cargo run" && cargo run'

# --- ssh ---
alias de='echo "ssh debian" && ssh debian'
alias dlm3u8='echo "ssh debian: dl-m3u8" && ssh soc@100.67.58.98 "/home/soc/bin/dl-m3u8"'
alias geta='echo "scp debian: ~/downloads/aria2/" && scp soc@100.67.58.98:/home/soc/downloads/aria2/'
alias niri='echo "TigerVNC → debian:5900" && lsof -tiTCP:5900 -sTCP:LISTEN >/dev/null 2>&1 || ssh -f -N -o ExitOnForwardFailure=yes -o ServerAliveInterval=30 -L 5900:127.0.0.1:5900 -p 2222 soc@100.67.58.98; nohup /Applications/TigerVNC.app/Contents/MacOS/vncviewer -FullScreen -FullScreenMode=Current 127.0.0.1:5900 >/dev/null 2>&1 &'

# --- ukulele ---
alias uke='echo "cd ~/Documents/Ukulele && npm run dev" && cd /Users/soc/Documents/Ukulele && npm run dev'
alias ukeb='echo "cd ~/Documents/Ukulele && nohup npm run dev > /tmp/uke-dev.log" && cd /Users/soc/Documents/Ukulele && nohup npm run dev > /tmp/uke-dev.log 2>&1 &'
alias ukek='lsof -tiTCP:5173 -sTCP:LISTEN | xargs kill'
alias ukel='tail -f /tmp/uke-dev.log'
# 练习用：构建后跑静态预览，不受源码改动影响（dev 会 HMR 重载，练习时别用）
alias ukep='echo "cd ~/Documents/Ukulele && npm run build && npm run preview" && cd /Users/soc/Documents/Ukulele && npm run build && nohup npm run preview > /tmp/uke-preview.log 2>&1 & sleep 3; echo "小U练习室 → http://localhost:4173/"'
alias ukepk='lsof -tiTCP:4173 -sTCP:LISTEN | xargs kill'

# --- uv ---
alias ur='echo "uv run" && uv run'

# ------------------------------
# Function
# ------------------------------

# 一键全量更新：Homebrew（复用 brewba，即 ba 的实现）→ Node/nvm 全局包 → dsh 核心
# 单步失败不中断，末尾汇总；有失败步骤时返回非 0
au() {
    setopt localoptions pipefail
    local cur
    local -a failed=()
    local -a pkgs

    echo "🍺 [1/3] 更新 Homebrew（系统工具和依赖）..."
    brewba || failed+=(Homebrew)
    echo "----------------------------------------"
    echo ""

    echo "🟢 [2/3] 更新 Node.js (nvm) 和 nvm 全局包（已排除 dsh，交 [3/3] 处理）..."
    if [[ ! -s "${NVM_DIR:-$HOME/.nvm}/nvm.sh" ]]; then
        echo "⚠️  未找到 nvm（${NVM_DIR:-$HOME/.nvm}），跳过 Node 更新"
    else
        [[ -n "${NVM_BIN:-}" ]] || lazy_load_nvm
        cur=$(nvm version 2>/dev/null)
        # 只能传字面量 current：nvm 发现来源 == 目标版本时直接 exit 4
        # （"You can't reinstall global packages from the same version"）
        if [[ "$cur" == v22.* ]]; then
            # 已在 22 大版本：只做补丁升级，离线或已是最新不算失败
            nvm install 22 --reinstall-packages-from=current ||
                echo "⚠️  Node 22 未能升级（可能已是最新或离线），继续使用 $cur"
        elif [[ "$cur" == v* ]]; then
            nvm install 22 --reinstall-packages-from=current || failed+=(Node)
        else
            nvm install 22 || failed+=(Node)
        fi
        nvm alias default 22 >/dev/null || failed+=(Node-default)
        npm install -g npm@latest || failed+=(npm)
        echo "📦 全局包可更新情况（已跳过 @deepseek-ai/*）："
        npm outdated -g 2>/dev/null | grep -v '^@deepseek-ai/' || true
        # parseable 输出取 /node_modules/ 之后的目录名；空输出时数组为空
        pkgs=(${(f)"$(npm ls -g --depth=0 --parseable 2>/dev/null | sed -n 's#^.*/node_modules/##p' | grep -v '^@deepseek-ai/' | grep -v '^npm$')"})
        if ((${#pkgs[@]})); then
            npm update -g "${pkgs[@]}" || failed+=(npm-globals)
        fi
        echo "ℹ️  Node: $(node -v 2>/dev/null), npm: $(npm -v 2>/dev/null)"
    fi
    echo "----------------------------------------"
    echo ""

    echo "🔍 [3/3] 检查并自动更新 dsh..."
    dshup || failed+=(dsh)
    echo "----------------------------------------"
    echo ""

    if ((${#failed[@]})); then
        print -u2 "⚠️  未成功的步骤: ${(j: / :)failed}"
        return 1
    fi
    echo "🎉 全部更新完成"
}

# 下载 B 站视频（自动合并 mp4）并转成 H.264；用法: bili <视频页URL>
bili() {
    yt-dlp --cookies-from-browser edge -P "$HOME/Downloads" \
        -f "bv*+ba/b" --merge-output-format mp4 \
        --exec 'h264ify {}' "$@"
}

# 只下载 B 站音频并转成 mp3；用法: bilia <视频页URL>
bilia() {
    yt-dlp --cookies-from-browser edge -P "$HOME/Downloads" \
        -f "ba/b" -x --audio-format mp3 --audio-quality 0 "$@"
}

# ba 的实现：brew update / upgrade / cleanup；输出逐行转斜体（终端下强制彩色）
brewba() {
    setopt localoptions pipefail
    local -a hb=(brew)
    [[ -t 1 ]] && hb=(env HOMEBREW_COLOR=1 brew)
    {
        "${hb[@]}" update &&
            ("${hb[@]}" upgrade 2>&1 | awk 'BEGIN{f=0} /Warning: Not upgrading [0-9]* pinned packages:/{f=1} {if(!f) print}') &&
            "${hb[@]}" cleanup
    } 2>&1 | italicize
}

# 列出 Debian 远程目录文件（方便复制确切文件名）
dlls() {
    ssh debian-home ls -lh "${1:-/home/soc/downloads/aria2/}"
}

# 从 Debian 拉文件到 Mac（断点续传 + 进度条）
dlpull() {
    if [[ -z "$1" ]]; then
        echo "Usage: dlpull <remote-path> [local-dest]" >&2
        return 1
    fi
    local src="$1"
    local dest="${2:-$HOME/Downloads/debian-pull/}"
    mkdir -p "$dest"
    rsync -avzPs "debian-home:$src" "$dest"
}

# 检查并更新 dsh 核心（装在 /opt/homebrew 前缀的 npm 全局包）
# 必须用 /opt/homebrew/bin/npm：nvm 的 npm 会把新版装进 nvm 前缀，PATH 上那份不动
dshup() {
    setopt localoptions pipefail
    local npm_bin=/opt/homebrew/bin/npm
    local root pkg cur latest path_dsh path_ver
    if [[ ! -x "$npm_bin" ]]; then
        print -u2 "⚠️  未找到 $npm_bin（Homebrew 的 node/npm 装了吗？）"
        return 1
    fi

    root=$("$npm_bin" root -g 2>/dev/null)
    # 只认 Homebrew 前缀：换成 nvm 的 npm 会把新版装进 nvm 前缀，PATH 上那份 dsh 不会变
    if [[ "$root" != /opt/homebrew/lib/node_modules ]]; then
        print -u2 "⚠️  npm root -g = ${root:-未知}，不是 Homebrew 前缀，已停止"
        return 1
    fi
    pkg="$root/@deepseek-ai/dsh/package.json"
    if [[ ! -r "$pkg" ]]; then
        print -u2 "⚠️  未找到 dsh 的 npm 全局安装（$pkg）"
        return 1
    fi

    cur=$(grep -m1 '"version"' "$pkg" | sed -n 's/.*"version": *"\([^"]*\)".*/\1/p')
    latest=$("$npm_bin" view @deepseek-ai/dsh version 2>/dev/null)
    if [[ -z "$latest" ]]; then
        print -u2 "⚠️  无法获取最新版本（检查网络/代理）"
        return 1
    fi

    if [[ "$cur" == "$latest" ]]; then
        echo "✅ dsh 已是最新 ($cur)"
    else
        echo "⬆️  发现新版: $latest（当前 ${cur:-未知}），依赖较多，约需 1-3 分钟..."
        if ! "$npm_bin" install -g \
            --allow-scripts=@deepseek-ai/dsh-subprocess-local,koffi,node-pty,@google/genai,protobufjs \
            @deepseek-ai/dsh@latest; then
            print -u2 "⚠️  dsh 更新失败"
            return 1
        fi
        cur=$(grep -m1 '"version"' "$pkg" | sed -n 's/.*"version": *"\([^"]*\)".*/\1/p')
        echo "✅ 更新完成: ${cur:-未知}"
    fi

    # nvm 加载后 PATH 上前缀是 nvm 的 bin，里面的旧 dsh 会遮住刚更新的这份
    path_dsh=$(whence -p dsh 2>/dev/null)
    if [[ -n "$path_dsh" && "$path_dsh" != /opt/homebrew/bin/dsh ]]; then
        path_ver=$("$path_dsh" --version 2>/dev/null)
        if [[ "$path_ver" != "$cur" ]]; then
            echo "⚠️  PATH 上的 dsh 是 $path_dsh（${path_ver:-未知}），与 Homebrew 版 $cur 不一致，旧副本会遮住新版"
        fi
    fi
    echo "ℹ️  重启 dsh web / 桌面版后新版本生效"
}

# 逐行包成斜体（kitty 的 italic_font）；每遇 \e[0m 重置后重新开启斜体，
# 非终端输出（重定向/管道）原样透传，避免转义符写进日志
italicize() {
    if [[ -t 1 ]]; then
        sed $'s/\x1b\\[0m/\x1b[0m\x1b[3m/g; s/^/\x1b[3m/; s/$/\x1b[0m/'
    else
        cat
    fi
}

# 让 sudo 支持 alias 展开
sudo() {
    if [[ -n "${aliases[$1]}" ]]; then
        eval "command sudo ${aliases[$1]} \${@:2}"
    elif type "$1" &>/dev/null; then
        command sudo "$@"
    else
        command sudo $(whence -p "$1") "${@:2}"
    fi
}

# yazi: cd to selected directory on exit
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    command yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd <"$tmp"
    [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$tmp"
    rm -f -- "$tmp"
}
