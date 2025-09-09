# export PATH=$HOME/bin:/usr/local/bin:$PATH
# echo source ~/.bash_profile

eval "$(brew shellenv)"
# source .zprofile in all zsh shells (just in case)
# [[ -f "$HOME/.zprofile" ]] && source "$HOME/.zprofile"

export ZSH="~/.oh-my-zsh"

# unbind ctrl g in terminal
bindkey -r "^G"

# Starship
bindkey -v
if [[ "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select" || \
      "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select-wrapped" ]]; then
    zle -N zle-keymap-select "";
fi
eval "$(starship init zsh)"

# Zoxide
eval "$(zoxide init zsh)"

# FZF
eval "$(fzf --zsh)"

# FZF with Git right in the shell by Junegunn : check out his github below
# Keymaps for this is available at https://github.com/junegunn/fzf-git.sh
source ~/.dotfiles/scripts/fzf-git.sh

# Atuin Configs
export ATUIN_NOBIND="true"
# eval "$(atuin init zsh)"
# bindkey '^r' _atuin_search_widget
bindkey '^r' atuin-up-search-viins
#User configuration
# export MANPATH="/usr/local/man:$MANPATH"

#----- Vim Editing modes & keymaps ------
set -o vi

export EDITOR=nvim
export VISUAL=nvim

bindkey -M viins '^E' autosuggest-accept
bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^N' down-line-or-history
#----------------------------------------

# Cores para man pages para facilitar leitura
export MANROFFOPT='-c'
typeset -A man_colors=(
  mb "$(tput bold; tput setaf 2)"        # Verde para títulos
  md "$(tput bold; tput setaf 6)"        # Ciano para descrições
  me "$(tput sgr0)"                       # Reset formatação
  so "$(tput bold; tput setaf 3; tput setab 4)" # Amarelo em fundo azul para destaque
  se "$(tput rmso; tput sgr0)"            # Reset destaque
  us "$(tput smul; tput bold; tput setaf 7)"     # Sublinhado branco para links
  ue "$(tput rmul; tput sgr0)"             # Reset sublinhado
  mr "$(tput rev)"                       # Inverter cores
  mh "$(tput dim)"                       # Texto em cinza
)
for key val in ${(kv)man_colors}; do
  export LESS_TERMCAP_$key=$val
done

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# zsh plugins
plugins=(
    git
    web-search
)

# other Aliases shortcuts
alias c="clear"
alias e="exit"
alias vim="nvim"

# Tmux
alias tmux="tmux -f $TMUX_CONF"
alias a="attach"
# calls the tmux new session script
alias tns="~/scripts/tmux-sessionizer"

# opens documentation through fzf (eg: git,zsh etc.)
alias fman="compgen -c | fzf | xargs man"

# zoxide (called from ~/scripts/)
alias nzo="~/scripts/zoxide_openfiles_nvim.sh"

# Navegação de diretórios rápida
alias ..='cd ..'                       # Sobe uma pasta
alias ...='cd ../..'                   # Sobe duas pastas
alias ....='cd ../../..'               # Sobe três pastas
alias .....='cd ../../../..'           # Sobe quatro pastas

# Next level of an ls
# options :  --no-filesize --no-time --no-permissions
if command -v eza &>/dev/null; then
  alias ls="eza --no-filesize --long --color=always --icons=always --no-user"
  alias ll="eza --icons --git --long --header"                   # Lista arquivos com ícones e infos git
  alias l="eza --icons --git --all --long --header"              # Lista todos arquivos, inclusive ocultos
  alias la="ls -AF --color=auto"                                # Lista arquivos com cores e símbolos
  alias lld="ls -l | grep ^d"                                   # Lista apenas diretórios
  alias rmf="rm -rf"                                            # Remove diretórios recursivamente forçado
fi

# tree
# alias tree="tree -L 3 -a -I '.git' --charset X "
alias tree="eza --tree"
alias dtree="tree -L 3 -a -d -I '.git' --charset X "

# lstr
alias lstr="lstr --icons"

# git aliases
alias gt="git"
alias ga="git add ."
alias gs="git status -s"
alias gc='git commit -m'
alias glog='git log --oneline --graph --all'
alias gh-create='gh repo create --private --source=. --remote=origin && git push -u --all && gh browse'

alias nvim-scratch="NVIM_APPNAME=nvim-scratch nvim"

# lazygit
alias lg="lazygit"

# bat
  if command -v bat &>/dev/null; then
  alias catt='bat'                       # Usa bat para saída colorida em arquivos
  alias cat='bat --paging=never --style=plain'
  alias cata='bat --show-all --paging=never --style=plain'
fi

# Utilitários práticos
alias reload='source ~/.zshrc'       # Recarrega config do zshrc
alias icat='kitty +kitten icat'       # Visualiza imagens no terminal Kitty
alias dif='kitty +kitten diff'        # Visualiza diferenças no Kitty
alias grep='grep --color=auto'       # grep com cores para facilitar leitura
alias df='df -h'                     # Usa unidades humanas (GB) para espaço em disco
alias du='du -h -c'                  # Tamanho legível de pastas e total
alias lpath='echo $PATH | tr ":" "\n"' # Lista PATH separando por linhas
alias ios='open -a /Applications/Xcode-15.0.0.app/Contents/Developer/Applications/Simulator.app' # Abre simulador iOS
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder" # Oculta ícones da área de trabalho macOS
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder" # Mostra ícones na área de trabalho macOS
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"   # Remove arquivos .DS_Store recursivamente
alias clsym="find -L . -name . -o -type d -prune -o -type l -exec rm {} +" # Remove links simbólicos quebrados

# obsidian icloud path
# alias sethvault="cd ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/sethVault/"
# ---------------------------------------

# brew installations activation (new mac systems brew path: opt/homebrew , not usr/local )
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

. "$HOME/.atuin/bin/env"
