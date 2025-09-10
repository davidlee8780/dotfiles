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

# Adiciona binários locais do usuário
export PATH="$HOME/.local/bin:$PATH"

# Adiciona versões GNU grep customizadas
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"

# Adiciona binários administrativos locais
export PATH="/usr/local/sbin:$PATH"

# Adiciona scripts customizados para Zsh
export PATH="$HOME/.dotfiles/config/zsh/bin:$PATH"

# Adiciona binários pessoais do usuário
export PATH="$HOME/bin:$PATH"

# Inicializa o ambiente do Homebrew (gerenciador de pacotes do macOS)
eval "$(brew shellenv)"

# Inicializa o fnm (gerenciador rápido de versões do Node.js) para mudar automaticamente de versão em pastas
eval "$(fnm env --use-on-cd --shell zsh)"
source "$HOME/.rye/env"

#Ruby
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"

# Tmux
export TMUX_CONF=~/.config/tmux/tmux.conf

# Added by Toolbox App
export PATH="$PATH:/Users/davidlee/Library/Application Support/JetBrains/Toolbox/scripts"
export XDG_CONFIG_HOME="$HOME/.config"

export EDITOR="nvim"
export VISUAL="nvim"

