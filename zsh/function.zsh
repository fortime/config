gbkunzip() {
    (
        () {
            set -e
            local filename tmp_dir

            filename=$(basename $1)
            tmp_dir="${filename}_dir"
            LC_ALL=C LANG=C 7z x -o"$tmp_dir" "$1"
            if [ "$?" != 0 ]
            then
                echo "unzip $1 failed!" >&2
                return 1
            fi
            convmv -f GBK -t utf8 --notest -r "$tmp_dir"
            mv "$tmp_dir/"* .
            rm -r "$tmp_dir"
        } "$@"
    )
}

cpdflatex() {
    (
        () {
            set -e
            local work_path filename filename_without_suffix tmp_dir

            work_path=$(cd $(dirname $1); pwd)
            #cd "$work_path"
            filename=$(basename $1)
            filename_without_suffix="${filename%.*}"
            tmp_dir="${work_path}/.${filename}_tex"
            mkdir "$tmp_dir"
            xelatex -output-directory="$tmp_dir" -halt-on-error -interaction=nonstopmode "$1"
            mv "$tmp_dir/${filename_without_suffix}.pdf" .
            rm -r "$tmp_dir"
        } "$@"
    )
}

cpnglatex() {
    (
        () {
            set -e
            local filename filename_without_suffix

            if [ -z "$2" ]
            then
                echo "resolution must be provided!" >&2
                return 1
            fi
            cpdflatex "$1"
            filename=$(basename $1)
            filename_without_suffix="${filename%.*}"
            if [ ! -f "${filename_without_suffix}.pdf" ]
            then
                echo "the pdf file hasn't been generated!" >&2
                return 1
            fi
            pdftoppm -png -r $2 "${filename_without_suffix}.pdf" > "${filename_without_suffix}.png"
        } "$@"
    )
}

vz() {
    local file
    file="$(fasd -Rfl "$1" | fzf-tmux -1 -0 --no-sort +m)" && vim "${file}" || return 1
}

lgsg() {
    local file
    file="$(git ls-files --recurse-submodules | fzf-tmux -1 -0 --no-sort +m --preview 'bat --color always {}')" && less "${file}" || return 1
}

bgsg() {
    local file
    file="$(git ls-files --recurse-submodules | fzf-tmux -1 -0 --no-sort +m --preview 'bat --color always {}')" && bat "$@" "${file}" || return 1
}

vgsg() {
    local file
    file="$(git ls-files -omc --directory | fzf-tmux -1 -0 --no-sort +m --preview 'bat --color always {}')" && vim "${file}" || return 1
}

gsg() {
    local file
    file="$(git ls-files -omc --directory | fzf-tmux -1 -0 --no-sort +m --preview 'bat --color always {}')" && echo "${file}" || return 1
}

hgsg() {
    local cmd confirm
    cmd="$(fc -lnr 1 | fzf-tmux -1 -0 --no-sort +m)"
    if [ $? -eq 0 ]
    then
        if [ -n "$WIDGET" ]
        then
            BUFFER="$cmd"
            CURSOR="$#BUFFER"
        else
            echo "$cmd"
        fi
    fi
}

_z() {
    local dir
    dir="$(fasd -Rdl "$1" | fzf-tmux -1 -0 --no-sort +m)" && cd "${dir}" || return 1
}

fh() {
    print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf-tmux +s --tac | sed 's/ *[0-9]* *//')
}

fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf-tmux -m | awk '{print $2}')

    if [ "x$pid" != "x" ]
    then
        kill -${1:-9} $pid
    fi
}

copy-for-fortify() {
    zsh ~/zsh/function/copy-for-fortify "$@"
}

gen-oss-licenses() {
    zsh ~/zsh/function/gen-oss-licenses "$@"
}

qemu-wrapper() {
    if [ "$1" = "cd" ]
    then
        cd $(zsh ~/zsh/function/qemu-wrapper pwd)
    else
        zsh ~/zsh/function/qemu-wrapper "$@"
    fi
}
