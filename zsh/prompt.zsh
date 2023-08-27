setopt PROMPT_SUBST

autoload -U promptinit && promptinit
autoload -U colors && colors

if [ -n "$commands[git]" ]
then
    git="$commands[git]"
else
    git="/usr/bin/git"
fi

git_branch() {
    echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
    local workspace
    local files
    local st
    local ret
    workspace=$(git rev-parse --show-toplevel 2>/dev/null)
    ret=$?
    if [ $ret -ne 0 ]
    then
        echo ""
        return
    fi

    cd "$workspace"
    files=$($git ls-files 2>/dev/null | wc -l)
    if [ $files -gt 10000 ]
    then
        echo "[%{$fg_bold[grey]%}$(git_prompt_info)%{$reset_color%}]"
        return
    fi
    st=$($git diff --shortstat 2>/dev/null)
    if [[ $st == "" ]]
    then
        st=$($git diff HEAD --shortstat 2>/dev/null)
        ret=$?
        if [[ "$st" == "" ]]
        then
            if [ $ret -eq 0 ]
            then
                echo "[%{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}]"
            else
                st=$($git status 2>/dev/null | tail -n 1)
                if [[ "$st" =~ ^nothing ]]
                then
                    echo "[%{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}]"
                else
                    echo "[%{$fg_bold[yellow]%}$(git_prompt_info)%{$reset_color%}]"
                fi
            fi
        else
            echo "[%{$fg_bold[yellow]%}$(git_prompt_info)%{$reset_color%}]"
        fi
    else
        echo "[%{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}]"
    fi
}

git_prompt_info () {
    local ref
    ref=$($git symbolic-ref HEAD 2>/dev/null)
    if [ $? -ne 0 ]
    then
        echo "$($git rev-parse --short HEAD)"
        return
    fi
    echo "${ref#refs/heads/}"
}

unpushed () {
    $git cherry -v @{upstream} 2>/dev/null
}

need_push () {
    if [[ $(unpushed) == "" ]]
    then
        echo " "
    else
        echo "[%{$fg_bold[magenta]%}unpushed%{$reset_color%}] "
    fi
}

function collapse_pwd {
    echo "%{$fg[yellow]%}$(pwd | sed -e "s,^$HOME,~,")%{$reset_color%}"
}

local USER_PROMPT
local HOST_PROMPT
local TTY_PROMPT
local DATETIME_PROMPT
local RETCODE_PROMPT
USER_PROMPT="%{$fg_bold[red]%}%n%{$reset_color%}"
HOST_PROMPT="%{$fg_bold[blue]%}%m%{$reset_color%}"
TTY_PROMPT="[%{$fg_no_bold[magenta]%}%l%{$reset_color%}]"
DATETIME_PROMPT="[%{$fg[cyan]%}%w %t%{$reset_color%}]"
RETCODE_PROMPT="[%{$fg_no_bold[yellow]%}%?%{$reset_color%}]"

PROMPT=$'\n${USER_PROMPT}@${HOST_PROMPT} on ${TTY_PROMPT} in $(collapse_pwd) $(git_dirty) $(need_push)\n${DATETIME_PROMPT} %#> '
RPROMPT=$'${RETCODE_PROMPT}'

#export PROMPT=$'\n$(rb_prompt)in $(directory_name) $(git_dirty)$(need_push)\n› '

if [ "$SSH_CONNECTION" != '' ]; then
    declare -a HOSTIP
    HOSTIP=`echo $SSH_CONNECTION |awk '{print $3}'`
    precmd () {print -Pn "\033]0;$HOSTIP:${PWD/#$HOME/~} \007"}
#elif [ "$TERM" = "xterm" ]; then
else
    precmd () {print -Pn "\e]0; %~\a"}
fi

