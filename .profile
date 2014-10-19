alias l='ls -l'
alias ll='ls -lA'
alias t='todo.sh'

alias hulk='ssh stefan@hulk.skeidel.de -p4321'

ulimit -n 2048

export EDITOR=vim
export VISUAL=vim

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH
