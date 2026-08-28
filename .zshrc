# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/share/cachyos-zsh-config/cachyos-config.zsh 

bindkey -v
bindkey '^ ' autosuggest-accept

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

# unalias gf
# GTK wayland 
unset GTK_IM_MODULE
unset QT_IM_MODULE
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/streamer/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
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
