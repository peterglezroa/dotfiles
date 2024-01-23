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
#
export EDITOR=nvim
alias vim="nvim"
alias vi="nvim"
