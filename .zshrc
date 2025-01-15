# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Plugin-list
export PATH=$PATH:/opt/core/venv/bin

# Add colors to commands
GRC_ALIASES=true
[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh

# Zinit setup
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Powerlevel10k and plugins
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Check and install missing programs
install_if_missing() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Installing $1..."
    sudo apt update && sudo apt install -y "$1"
  }
}

## Programs
install_if_missing lsd

# Fzf setup
if [ ! -d "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
fi

# Pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
if [ ! -d "$PYENV_ROOT" ]; then
  curl https://pyenv.run | bash
fi
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Zsh settings
setopt autocd correct interactivecomments magicequalsubst nonomatch notify numericglobsort promptsubst
WORDCHARS=${WORDCHARS//\/}
PROMPT_EOL_MARK=""
autoload -Uz compinit && compinit -d ~/.cache/zcompdump

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_expire_dups_first hist_ignore_dups hist_ignore_space hist_verify share_history hist_save_no_dups hist_find_no_dups
alias history="history 0"

# Prompt configuration
configure_prompt() {
  case "$PROMPT_ALTERNATIVE" in
    twoline)
      PROMPT='%F{blue}┌──[%n@%m]%F{reset}%~\n%F{blue}└─%#%F{reset} '
      ;;
    oneline)
      PROMPT='%F{blue}[%n@%m]%F{reset}%~ %# '
      ;;
  esac
}
PROMPT_ALTERNATIVE=twoline
configure_prompt

# Keybindings
bindkey -e
bindkey ' ' magic-space
bindkey '^U' backward-kill-line
bindkey '^[[3;5~' kill-word
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Aliases and environment
alias ls='lsd --color=auto'
alias grep='grep --color=auto'

# Terminal title
precmd() {
  print -Pn "\e]0;%n@%m: %~\a"
}

# Completion settings
zstyle ':completion:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' verbose true
zstyle ':completion:*' verbose true

# Set `fzf-tab` behavior for the `cd` command
zstyle 'fzf-tab:_complete:cd' fzf-preview 'ls --color $realpath'

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=200000
setopt hist_expire_dups_first  # Delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups        # Ignore duplicate commands in history
setopt hist_ignore_space       # Ignore commands that start with a space
setopt hist_verify             # Show expanded history commands before executing
setopt share_history           # Share history between all zsh sessions
setopt hist_save_no_dups       # Prevent saving duplicate commands
setopt hist_find_no_dups       # Prevent showing duplicates in search results

# Alias for full command history
alias history="history 0"

# Configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# Ensure color support for `ls`, `less`, `man`, etc., and define aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # Fix color for 777-permission directories

    alias ls='lsd --color=auto'
    alias dir='dir --color=auto'
    alias cat='cat -n'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m' # Begin bold
    export LESS_TERMCAP_md=$'\E[1;38;5;74m' # Bold bright blue
    export LESS_TERMCAP_me=$'\E[0m'    # End bold
    export LESS_TERMCAP_se=$'\E[0m'    # Reset
    export LESS_TERMCAP_so=$'\E[01;33m' # Standout
    export LESS_TERMCAP_ue=$'\E[0m'    # End underline
    export LESS_TERMCAP_us=$'\E[1;32m' # Start underline
fi

# Checks and installs for required programs
function ensure_program_installed() {
    local prog_name=$1
    local install_cmd=$2

    if ! command -v "$prog_name" &>/dev/null; then
        echo "$prog_name is not installed. Installing..."
        eval "$install_cmd"
    fi
}

ensure_program_installed "lsd" "sudo apt install -y lsd"
ensure_program_installed "pyenv" "curl https://pyenv.run | bash"

# Preconfigure `tmux` with optional configuration
if command -v tmux &>/dev/null && [ ! -f ~/.tmux.conf ]; then
  install_if_missing tmux
  ensure_program_installed "tmux" "sudo apt install -y tmux"
  echo "Installing tmux Plugin Manager (TPM)"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    while true; do
        read -r -p "Do you wish to use a preconfiguration for tmux? [y/N]: " yn
        case $yn in
            [Yy]*) wget -O ~/.tmux.conf https://raw.githubusercontent.com/PineApple-Logic/zsh/refs/heads/master/.tmux.conf; break ;;
            [Nn]*) break ;;
            *) echo "Please answer yes or no." ;;
        esac
    done
fi

# Apply `Powerlevel10k` configuration
[[ ! -f ~/.p10k.zsh ]] && p10k configure

# Final environment configuration
export EDITOR="vim"
export VISUAL="vim"

# Load additional configurations if present
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases
[ -f ~/.zsh_functions ] && source ~/.zsh_functions

# Clean up temporary variables
unset ZINIT_HOME
unset prompt_symbol
unset prompt_symbol

# Configure Zsh plugins and frameworks
# If Zinit is available, load plugins
if [ -n "$ZINIT_HOME" ] && [ -d "$ZINIT_HOME" ]; then
    source "$ZINIT_HOME/zinit.zsh"
    zinit light zsh-users/zsh-autosuggestions
    zinit light zsh-users/zsh-syntax-highlighting
    zinit light zdharma-continuum/fast-syntax-highlighting
    zinit light junegunn/fzf-tab
    zinit light romkatv/powerlevel10k
fi

# Custom key bindings for better navigation and productivity
bindkey '^[[H' beginning-of-line  # Home key to move to the start of the line
bindkey '^[[F' end-of-line        # End key to move to the end of the line
bindkey '^[[3~' delete-char       # Delete key to delete characters
bindkey '^[[Z' reverse-menu-complete  # Shift+Tab for reverse completion

# Functions for dynamic productivity
# Easily search Zsh history
function hgrep() {
    history | grep --color=auto "$@"
}

# Create and navigate to a directory
function mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Update all relevant tools and dependencies
function update_all() {
    echo "Updating system packages..."
    sudo apt update && sudo apt upgrade -y
    echo "Updating Zsh plugins..."
    [ -n "$ZINIT_HOME" ] && zinit self-update && zinit update --all
    echo "Updating pyenv versions..."
    command -v pyenv &>/dev/null && pyenv update
    echo "Updating fzf..."
    ~/.fzf/install --all
    echo "All updates completed!"
}

# Custom prompt tweaks (if needed)
export PROMPT='%F{cyan}%n@%m%f %F{yellow}%~%f %# '

# Load fzf key bindings and completion if installed
if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
fi

# Optional: Configure the PATH for custom binaries or tools
# Ensure user bin directories are included in PATH
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Optional: Add Go, Rust, or other language environments to PATH
if [ -d "$HOME/.cargo/bin" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi
if [ -d "$HOME/go/bin" ]; then
    export PATH="$HOME/go/bin:$PATH"
fi

# Apply terminal-specific configurations
case "$TERM" in
    xterm*|rxvt*)
        export TERM="xterm-256color"
        ;;
esac

# Run custom initialization scripts if present
for file in ~/.zshrc.d/*.zsh; do
    [ -r "$file" ] && source "$file"
done

# Final cleanup
unset file

# Optional: Enable shared history for better sync between terminal sessions
setopt SHARE_HISTORY

# Optional: Configure the editor for command-line editing
export EDITOR=nano  # Change to 'vim' or 'code' if you prefer

# Optional: Enable more detailed error messages
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Optional: Add a fortune message on terminal startup
if command -v fortune &>/dev/null; then
    echo
    fortune | cowsay -f tux
    echo
fi

# Optional: Automatically update the terminal title
case $TERM in
    xterm*|rxvt*|screen*)
        precmd() { print -Pn "\e]0;%n@%m: %~\a" }
        ;;
esac

# Optional: Improve battery status display on laptops
if command -v acpi &>/dev/null; then
    alias battery='acpi -i'
fi

# Debugging support (toggle via environment variable)
if [[ -n $ZSH_DEBUG ]]; then
    set -x
else
    set +x
fi

# Log when the shell session starts (useful for audit or debugging purposes)
echo "Session started at $(date)" >> ~/.zsh_session_log

# Comment with versioning note for future reference
# This .zshrc was last updated on: 2025/01/15

# Done!
echo "Welcome to your enhanced Zsh environment! 🚀"

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi
