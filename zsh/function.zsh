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

copy_for_fortify() {
    _copy_for_fortify() {
        print_help() {
            [ -z "$1" ] || echo "$1" >&2
            echo -e "
The command should be run like:
  copy_for_fortify <dst-path> [src-path[:src-tree-ish]]" >&2
            exit 1
        }

        run() {
            set -e
            local dst_path="$1"
            local src
            [ -d "$dst_path" ] && rm -r "$dst_path"
            mkdir -p "$dst_path"
            while read src
            do
                local src_path=$(echo "$src" | cut -d: -f1)
                if [ ! -d "$src_path" ]
                then
                    echo "$src_path not exist"
                    continue
                fi
                local src_tree_ish=$(echo "$src" | cut -d: -f2 -s)
                if [ -z "$src_tree_ish" ]
                then
                    src_tree_ish=HEAD
                fi
                echo "copying $src_path:$src_tree_ish to $dst_path"
                local default_service_name=$(basename "$src_path")
                local service_name=$(echo "$src" | cut -d: -f3 -s)
                if [ -z "$service_name" ]
                then
                    service_name=$default_service_name
                fi
                local sub_path=$(echo "$src" | cut -d: -f4 -s)
                if [ -z "$sub_path" ]
                then
                    (
                        cd "$src_path";
                        git fetch;
                        git archive --format=tar --prefix="$service_name/" "$src_tree_ish" | (cd "$dst_path" && tar xf -)
                    )
                else
                    (
                        cd "$src_path";
                        git fetch;
                        cd "$sub_path";
                        git archive --format=tar --prefix="$service_name/" "$src_tree_ish" | (cd "$dst_path" && tar xf -)
                    )
                fi
                [ -d "${dst_path}/${service_name}/src/test" ] && rm -r "${dst_path}/${service_name}/src/test"
                [ -d "${dst_path}/${service_name}/src/main/resources/i18n" ] && rm -r "${dst_path}/${service_name}/src/main/resources/i18n"
                find "${dst_path}/${service_name}" -name "application-*" -delete
                find "${dst_path}/${service_name}" -name "bootstrap-*" -delete
                find "${dst_path}/${service_name}" -name "logback-*" -delete
                find "${dst_path}/${service_name}" -name "log4j2-*" -delete
                find "${dst_path}/${service_name}" -name "Dockerfile" -delete
                find "${dst_path}/${service_name}" -name "dockerfile" -delete
                find "${dst_path}/${service_name}" -name "MybatisGenerator.java" -delete
                find "${dst_path}/${service_name}" -name "application.yaml" -exec sed -I "" '/login-username: admin/d;/login-password/d;/ssl:/N;/ssl:\n[^a-zA-Z0-9]*enabled: false/d' {} \;
                find "${dst_path}/${service_name}" -name "bootstrap.yaml" -exec sed -I "" '/password/d;/username/d;' {} \;
                if [ -f "${dst_path}/${service_name}/pom.xml" ]
                then
                    (cd "${dst_path}/${service_name}"; mkdir libs; mvn org.apache.maven.plugins:maven-dependency-plugin:copy-dependencies -DincludeScope=compile -DoutputDirectory=libs -Dmdep.failOnMissingClassifierArtifact=false -DincludeGroupIds=com.sensetime.arcloud)
                fi
                (cd "${dst_path}/"; zip -rq "${service_name}.zip" "${service_name}")
            done
        }

        local dst_path="$1"
        local src_path="$2"
        if [ -z "$dst_path" ]
        then
            print_help "The destination path should be provided!"
            exit 1
        fi
        if [ -n "$src_path" ]
        then
            run "$dst_path" <<EOF
$src_path
EOF
        else
            run "$dst_path"
        fi
    }

    (_copy_for_fortify "$@")
    ret=$?
    unset -f _copy_for_fortify
    return $ret
}

gen_oss_licenses() {
    _gen_oss_license() {
        print_help() {
            [ -z "$1" ] || echo "$1" >&2
            echo -e "
The command should be run like:
  gen_oss_licenses <dst_path> [ftl_template_path [src-path]]" >&2
            exit 1
        }

        run() {
            set -e
            local dst_path="$1"
            # absolute path
            local ftl_template_path=$(cd $(dirname "$2"); pwd)/$(basename "$2")
            local src
            cat /dev/null > "$dst_path"
            local template_param=""
            if [ -n "$ftl_template_path" ]
            then
                template_param="-Dlicense.fileTemplate=$ftl_template_path"
            fi
            while read src
            do
                local src_path=$(echo "$src" | cut -d: -f1)
                if [ ! -d "$src_path" ]
                then
                    echo "$src_path not exist"
                    continue
                fi
                echo "generating oss licenses of $src_path to $dst_path"
                local service_name=$(basename "$src_path")
                if [ -f "${dst_path}/${service_name}/pom.xml" ]
                then
                    (cd "$src_path"; mvn license:add-third-party "$template_param" && cat target/generated-sources/license/THIRD-PARTY.txt >> "$dst_path")
                fi
            done
            sort "$dst_path" > "${dst_path}.tmp"
            uniq "${dst_path}.tmp" > "$dst_path"
            rm "${dst_path}.tmp"
        }

        local dst_path="$1"
        local ftl_template_path="$2"
        local src_path="$3"
        if [ -z "$dst_path" ]
        then
            print_help "The destination path should be provided!"
            exit 1
        fi
        if [ -n "$src_path" ]
        then
            run "$dst_path" "$ftl_template_path" <<EOF
$src_path
EOF
        else
            run "$dst_path" "$ftl_template_path"
        fi
    }

    (_gen_oss_license "$@")
    ret=$?
    unset -f _gen_oss_license
    return $ret
}
