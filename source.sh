#!/usr/bin/env bash
#i
# @name bash-source
# @brief Improve Bash's `source` into more modular system.
# @description bash-source is a simple script that patches `source` into a more `import`-like function.
#
# In a few words, patched `source` let you use it as how `import` function in modern languages.
# ```bash
# #!/usr/bin/env bash
#
# source source.sh
# source Module
#
# mod #=> Hello World!
# ```
#
# Learn more about it [on Github](https://github.com/UrNightmaree/bash-source)

declare -rp SOURCE_VERSION >/dev/null 2>&1 &&
    return 0

# @description Version of bash-source
declare -r SOURCE_VERSION="0.3.1"

# @description An array containing search paths of `source`.
declare -a SOURCE_PATH=(
    "$HOME/.local/share/bash/%s"
    "$HOME/.local/share/bash/%s.sh" "$HOME/.local/share/bash/%s.bash"
    "./%s"
    "./%s.sh" "./%s.bash"
)

# @description An array containing searcher functions of `source`.
declare -a SOURCE_SEARCHERS=()

__alt_realpath() {
    local old_pwd;old_pwd="$(pwd)"
    cd "${1%/*}" >/dev/null 2>&1 || :
    realpath "$(basename "$1")"
    cd "$old_pwd" || exit
}

SOURCE_SEARCHERS+=(__source_searchers_default)
# @description A default searcher.
# @internal
__source_searchers_default() {
    local script_name="$1"

    local -a attempted_path=()
    local found_path error

    local full_path
    full_path="$(__alt_realpath "$script_name")"
    
    if [[ -e "$full_path" ]]; then
        found_path="$full_path"
        error=0
    else
        attempted_path+=("$full_path")
        error=1
    fi

    if (( error )); then
        for fpath in "${SOURCE_PATH[@]}"; do
            local path
            path="$(printf "$fpath%s" "$script_name" "")"

            if [[ -e "$path" ]]; then
                found_path="$path"
                error=0
                break
            else
                attempted_path+=("$path")
                error=1
            fi
        done
    fi

    if (( error )); then
        echo "${attempted_path[@]}"
        return 1
    else
        echo "$found_path"
    fi
}

# @description A patched `source` function. In package search, `$1` append to list paths in `SOURCE_PATH` with suffix `.sh` or `.bash`. In script search, `$1` append to list paths in `SOURCE_PATH`.
# @arg $1 script Script name.
# @arg $@ args Arguments passed to script.
# shellcheck disable=SC2120 # it's a function
source() {
    __0="${__0:-source}"
    if ! (( $# )); then
        echo "$__0: error: script name is required" >&2
        return 2
    fi

    local name="$1"; shift

    local -a failed_paths=()
    local status_searcher error

    for searcher in "${SOURCE_SEARCHERS[@]}"; do
        local path
        path="$("$searcher" "$name")"
        status_searcher="$?"

        if (( status_searcher )); then
            IFS=' ' read -ra array <<< "$path"
            failed_paths+=("${array[@]}")
            error=1
        else
            error=0
            break
        fi
    done

    if (( error )); then
        printf "%s$__0: error: no script called '$name'\n" "" >&2

        for failed_path in "${failed_paths[@]}"; do
            printf "%s\tno file '$failed_path'\n" "" >&2
        done

        exit 1
    else
        builtin source "$path" "$@"
    fi
}

# @description Alias for `source`.
# @arg $1 script Script name.
# @arg $@ args Arguments passed to script.
# @see source
# shellcheck disable=SC1090 # it's a function
.() { __0='.' source "$@"; }

export -f source
export -f .
export SOURCE_SEARCHERS
export SOURCE_PATH
