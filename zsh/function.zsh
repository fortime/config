gbkunzip() {
    filename=$(basename $1)
    tmp_dir="${filename}_dir"
    LANG=C 7za x -o"$tmp_dir" "$1"
    if [ "$?" != 0 ]
    then
        echo "unzip $1 failed!" >&2
        return 1
    fi
    convmv -f GBK -t utf8 --notest -r "$tmp_dir"
    mv "$tmp_dir/"* .
    rm -r "$tmp_dir"
}

cpdflatex() {
    work_path=$(cd $(dirname $1); pwd)
    cd "$work_path"
    filename=$(basename $1)
    filename_without_suffix="${filename%.*}"
    tmp_dir=".${filename}_tex"
    mkdir "$tmp_dir"
    xelatex -output-directory="$tmp_dir" -halt-on-error -interaction=nonstopmode "$filename"
    mv "$tmp_dir/${filename_without_suffix}.pdf" .
    rm -r "$tmp_dir"
}

cpnglatex() {
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
    file="$(git ls-files --recurse-submodules | fzf-tmux -1 -0 --no-sort +m --preview 'bat --color always {}')" && bat "${file}" || return 1
}

vgsg() {
    local file
    file="$(git ls-files -omc --directory | fzf-tmux -1 -0 --no-sort +m --preview 'bat --color always {}')" && vim "${file}" || return 1
}

gsg() {
    local file
    file="$(git ls-files -omc --directory | fzf-tmux -1 -0 --no-sort +m --preview 'bat --color always {}')" && echo "${file}" || return 1
}

_z() {
    local dir
    dir="$(fasd -Rdl "$1" | fzf-tmux -1 -0 --no-sort +m)" && cd "${dir}" || return 1
}

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
