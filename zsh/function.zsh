function gbkunzip() {
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

function cpdflatex() {
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

function cpnglatex() {
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
