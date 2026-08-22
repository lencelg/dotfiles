# shellcheck shell=bash
# shellcheck disable=SC2034
# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return ;;
esac

export HISTSIZE=1000
export HISTFILESIZE=5000

eval "$(fzf --bash)"

set -o vi

BASH_IT="$HOME/.bash_it"

export BASH_IT_THEME="bobby"

source "${BASH_IT?}/bash_it.sh"

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
alias ga="git add"
alias gcmsg="git commit -m"
alias gss="git status"
alias cat="bat"
alias ls='lsd'
alias l='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'
alias lt='lsd --tree'
alias c="clear"
alias vi="nvim"
alias gp="git push"
alias blog="cd ~/code/gh/lencelg.github.io/"
alias lg="lazygit"
alias f="fastfetch"

export PATH="$HOME/.cargo/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/streamer/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/streamer/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/streamer/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/streamer/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
