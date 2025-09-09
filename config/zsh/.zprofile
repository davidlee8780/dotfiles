# .zprofile é carregado para shells de login (quando você abre um terminal novo)

if [[ -f /opt/homebrew/bin/brew ]]; then
    # Homebrew exists at /opt/homebrew for arm64 macos
    eval $(/opt/homebrew/bin/brew shellenv)
elif [[ -f /usr/local/bin/brew ]]; then
    # or at /usr/local for intel macos
    eval $(/usr/local/bin/brew shellenv)
elif [[ -d /home/linuxbrew/.linuxbrew ]]; then
    # or from linuxbrew
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Define o PATH com diretórios essenciais para que o sistema e programas encontrem comandos
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:/usr/local/opt/grep/libexec/gnubin:/usr/local/sbin:$HOME/.dotfiles/config/zsh/bin:$HOME/bin:$PATH"

# Inicializa o ambiente do Homebrew (gerenciador de pacotes do macOS)
eval "$(brew shellenv)"

# Inicializa o fnm (gerenciador rápido de versões do Node.js) para mudar automaticamente de versão em pastas
eval "$(fnm env --use-on-cd --shell zsh)"
source "$HOME/.rye/env"

# Tmux
export TMUX_CONF=~/.config/tmux/tmux.conf

# Added by Toolbox App
export PATH="$PATH:/Users/davidlee/Library/Application Support/JetBrains/Toolbox/scripts"
export XDG_CONFIG_HOME="$HOME/.config"

export EDITOR="nvim"
export VISUAL="nvim"

