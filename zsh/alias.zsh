alias -s html=$BROWSER
alias -s org=$BROWSER
alias -s php=$BROWSER
alias -s com=$BROWSER
alias -s net=$BROWSER
alias -s png=gpicview
alias -s jpg=gpicview
alias -s gif=gpicview
alias -s PNG=gpicview
alias -s JPG=gpicview
alias -s GIF=gpicview
alias -s sxw=soffice
alias -s doc=soffice
alias -s gz='tar -xzvf'
alias -s bz2='tar -xjvf'
alias -s java=$EDITOR
alias -s txt=$EDITOR
alias -s PKGBUILD=$EDITOR

# Normal aliases
alias grep='grep --color=auto'
alias ls='ls --color=auto -F --time-style=long-iso'
alias ll='ls --color=auto -F --time-style=long-iso -l'
alias lsd='ls -ld *(-/DN)'
alias lsa='ls -ld .*'
#alias f='find |grep'
#alias c="clear"
#alias dir='ls -1'
alias gvim='gvim -geom 82x35'
alias ..='cd ..'
#alias ppp-on='sudo /usr/sbin/ppp-on'
#alias ppp-off='sudo /usr/sbin/ppp-off'
#alias firestarter='sudo su -c firestarter'
#alias mpg123='mpg123 -o oss'
#alias mpg321='mpg123 -o oss'
#alias vba='/home/paul/downloads/VisualBoyAdvance -f 4'
alias hist="grep '$1' /home/paul/.zsh_history"
#alias irssi="irssi -c irc.freenode.net -n yyz"
alias mem="free -m"
alias top=htop

# command L equivalent to command |less
#alias -g L='|less'

# command S equivalent to command &> /dev/null &
#alias -g S='&> /dev/null &'

v() {
    local file
    file="$(fasd -Rfl "$1" | fzf-tmux -1 -0 --no-sort +m)" && vim "${file}" || return 1
}

_z() {
    local dir
    dir="$(fasd -Rdl "$1" | fzf-tmux -1 -0 --no-sort +m)" && cd "${dir}" || return 1
}
alias z=_z

fh() {
    print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf-tmux +s --tac | sed 's/ *[0-9]* *//')
}

fkill() {
    pid=$(ps -ef | sed 1d | fzf-tmux -m | awk '{print $2}')

    if [ "x$pid" != "x" ]
    then
        kill -${1:-9} $pid
    fi
}
