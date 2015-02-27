# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=8192
SAVEHIST=8192
# End of lines configured by zsh-newuser-install
VBOX_USB=usbfs

# Vars used later on by Zsh
export EDITOR=vim
export BROWSER=firefox
#export XTERM="aterm +sb -geometry 80x29 -fg black -bg lightgoldenrodyellow -fn -xos4-terminus-medium-*-normal-*-14-*-*-*-*-*-iso8859-15"

# This will set the default prompt to the walters theme

setopt PROMPT_SUBST
#setopt autopushd pushdminus pushdsilent pushdtohome
#setopt autocd
#setopt cdablevars
#setopt ignoreeof
#setopt interactivecomments
#setopt nobanghist
#setopt noclobber
#setopt HIST_REDUCE_BLANKS
#setopt HIST_IGNORE_SPACE
#setopt SH_WORD_SPLIT
#setopt nohup
#
eval `dircolors -b`

source ~/zsh/config.zsh
source ~/zsh/aliases.zsh
source ~/zsh/completion.zsh
source ~/zsh/prompt.zsh
source ~/zsh/bindkeys.zsh
[ -f ~/zsh/customize.zsh ] && source ~/zsh/customize.zsh
