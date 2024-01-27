# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/peterglezroa/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# bin
path+=('/home/peterglezroa/.local/bin')
export PATH

# Powerline
powerline-daemon -q
. /usr/share/powerline/bindings/zsh/powerline.zsh

# Pywal
wal -R

# Z script
. $HOME/.local/bin/z.sh

#
export EDITOR=nvim
alias vim="nvim"
alias vi="nvim"
alias yeet="git push"
alias venv="source .venv/bin/activate"

