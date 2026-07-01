# Port of the Bash-it "bobby" theme to Oh My Zsh
# Place this file in $ZSH_CUSTOM/themes/bobby.zsh-theme and set ZSH_THEME="bobby"

# Load color support
autoload -U colors && colors

# -------------------------------------------------------------------
# Map Bash-it color variables to zsh color sequences
# (These will be used in the prompt and git variables)
# -------------------------------------------------------------------
red="$fg[red]"
bold_green="$fg_bold[green]"
green="$fg[green]"
yellow="$fg[yellow]"
purple="$fg[magenta]"
bold_cyan="$fg_bold[cyan]"
reset_color="$reset_color"

# -------------------------------------------------------------------
# Clock configuration (from the original theme)
# -------------------------------------------------------------------
THEME_SHOW_CLOCK_CHAR="${THEME_SHOW_CLOCK_CHAR:-true}"
THEME_CLOCK_CHAR_COLOR="${THEME_CLOCK_CHAR_COLOR:-$red}"
THEME_CLOCK_COLOR="${THEME_CLOCK_COLOR:-$bold_cyan}"
THEME_CLOCK_FORMAT="${THEME_CLOCK_FORMAT:-"%Y-%m-%d %H:%M:%S"}"

# -------------------------------------------------------------------
# Git prompt style (mapped from SCM/GIT_THEME_PROMPT_*)
# -------------------------------------------------------------------
ZSH_THEME_GIT_PROMPT_PREFIX=" ${green}|"
ZSH_THEME_GIT_PROMPT_SUFFIX="${green}|"
ZSH_THEME_GIT_PROMPT_DIRTY=" ${red}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" ${bold_green}✓"

# -------------------------------------------------------------------
# Helper functions
# -------------------------------------------------------------------

# Coloured clock string
_bobby_clock_prompt() {
  echo -n "${THEME_CLOCK_COLOR}$(date +"${THEME_CLOCK_FORMAT}")${reset_color}"
}

# Unicode clock face character (🕛, 🕐, …)
_bobby_clock_char() {
  local hour=$(date +%H)
  local clock_chars=( 🕛 🕐 🕑 🕒 🕓 🕔 🕕 🕖 🕗 🕘 🕙 🕚 )
  local idx=$(( hour % 12 + 1 ))
  echo -n "${THEME_CLOCK_CHAR_COLOR}${clock_chars[idx]}${reset_color}"
}

# Combined clock output (time + optional clock char)
_bobby_clock() {
  echo -n "$(_bobby_clock_prompt) "
  if [[ "${THEME_SHOW_CLOCK_CHAR}" == "true" ]]; then
    echo -n "$(_bobby_clock_char) "
  fi
}

# -------------------------------------------------------------------
# Precmd function – builds the prompt dynamically
# -------------------------------------------------------------------
prompt_bobby_precmd() {
  # Battery (use Bash-it's battery_char or OMZ's battery_pct_prompt)
  local battery=""
  if (( $+functions[battery_char] )); then
    battery="$(battery_char) "
  elif (( $+functions[battery_pct_prompt] )); then
    battery="$(battery_pct_prompt) "
  fi

  local clock="$(_bobby_clock)"
  local ruby="$(ruby_prompt_info)"
  local git="$(git_prompt_info)"

  PS1="
${battery}${clock}${yellow}${ruby} ${purple}%m ${reset_color}in ${green}%~
%B${bold_cyan}${git}%b ${green}→${reset_color} "
}

# Register the precmd hook
autoload -U add-zsh-hook
add-zsh-hook precmd prompt_bobby_precmd
