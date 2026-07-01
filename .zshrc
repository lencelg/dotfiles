export ZSH="/usr/share/oh-my-zsh"

ZSH_THEME="murilasso"
# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
[[ -z "${plugins[*]}" ]] && plugins=(git fzf extract)

source $ZSH/oh-my-zsh.sh

# Ignore commands that start with spaces and duplicates.
export HISTCONTROL=ignoreboth

# Don't add certain commands to the history file.
export HISTORY_IGNORE="(\&|[bf]g|c|clear|history|exit|q|pwd|* --help)"

# Use custom `less` colors for `man` pages.
export LESS_TERMCAP_md="$(tput bold 2> /dev/null; tput setaf 2 2> /dev/null)"
export LESS_TERMCAP_me="$(tput sgr0 2> /dev/null)"

# Make new shells get the history lines from all previous
# shells instead of the default "last window closed" history.
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

# Fish-like syntax highlighting and autosuggestions
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Use history substring search
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# pkgfile "command not found" handler
source /usr/share/doc/pkgfile/command-not-found.zsh

export FZF_BASE=/usr/share/fzf

bindkey -v

# alias config
alias search="pacman -Ss"
alias ins="sudo pacman -S"
alias rem="sudo pacman -R"
alias fm="yazi"
alias query="pacman -Qs"
alias mingw="x86_64-w64-mingw32-gcc"
alias con="cd ~/.config"
alias update="sudo pacman -Syu"
alias info="pacman -Si"
alias work="cd ~/code/"
alias note="cd ~/code/note/2026/"
alias zed="zeditor"
alias ga="git add"
alias gcmsg="git commit -m"
alias gss="git status"
alias cat="bat"
alias ls='lsd'
alias l='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'
alias lt='lsd --tree'
alias lab="cd ~/code/jnu_course/lab/"
alias c="clear"
alias vi="nvim"
alias gp="git push"
alias blog="cd ~/code/gh/lencelg.github.io/"
alias lg="lazygit"
alias toy="cd ~/code/gh/toys/"
alias d2l="cd ~/code/d2l/"
alias f="fastfetch"
alias rev="cd ~/code/jnu_course/review/"

[ -f /opt/miniforge/etc/profile.d/conda.sh ] && source /opt/miniforge/etc/profile.d/conda.sh
# unalias gf
# GTK wayland 
unset GTK_IM_MODULE
unset QT_IM_MODULE
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
