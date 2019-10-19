function gbkunzip() {
    work_path=$(cd $(dirname $1); pwd)
    cd "$work_path"
    file_name=$(basename $1)
    dir_name="${file_name}_dir"
    LANG=C 7za x -o"$dir_name" "$file_name"
    convmv -f GBK -t utf8 --notest -r "$dir_name"
    mv "$dir_name/"* .
    rm -r "$dir_name"
}

function cpdflatex() {
    work_path=$(cd $(dirname $1); pwd)
    cd "$work_path"
    file_name=$(basename $1)
    dir_name=".${file_name}_tex"
    mkdir "$dir_name"
    xelatex -output-directory="$dir_name" -halt-on-error -interaction=nonstopmode "$file_name"
    mv "$dir_name/"*.pdf .
    rm -r "$dir_name"
}
