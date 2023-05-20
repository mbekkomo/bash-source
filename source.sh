#!/usr/bin/env bash
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

# @description An array containing search paths of `source`.
declare -a SOURCE_PATH=("." "$HOME/.local/share/bash")
# @description An array containing searcher functions of `source`.
declare -a SOURCE_SEARCHERS=()

SOURCE_SEARCHERS+=(__source_searchers_default_script)
# @description A searcher for script file.
# @internal
__source_searchers_default_script() {
    local script_path="$1"

    local -a attempted_path=()
    local found_path error

    for path in "${SOURCE_PATH[@]}"; do
        if [[ -e "$path/$script_path" ]]; then
            found_path="$path/$script_path"
            error=0
            break
        else
            attempted_path+=("$path/$script_path")
            error=1
        fi
    done

    if (( error )); then
        echo "${attempted_path[@]}"
        return 1
    else
        echo "$found_path"
    fi
}

SOURCE_SEARCHERS+=(__source_searchers_default_package)
# @description A searcher for package file.
# @internal
__source_searchers_default_package() {
    local package_name="$1"
    local fpackage_name="pkg_%s"

    local -a attempted_path=()
    local found_path error

    for path in "${SOURCE_PATH[@]}"; do
        local package_path_sh
        # shellcheck disable=SC2059 # i want to DRY
        package_path_sh="$path/$(printf "$fpackage_name" "$package_name").sh"
        local package_path_bash
        # shellcheck disable=SC2059 # same as above
        package_path_bash="$path/$(printf "$fpackage_name" "$package_name").bash"

        if [[ -e "$package_path_sh" ]]; then
            found_path="$package_path_sh"
            error=0
            break
        elif [[ -e "$package_path_bash" ]]; then
            found_path="$package_path_bash"
            error=0
            break
        else
            attempted_path+=("$package_path_sh" "$package_path_bash")
            error=1
        fi
    done

    if (( error )); then
        echo "${attempted_path[@]}"
        return 1
    else
        echo "$found_path"
    fi
}

# @description A patched `source` function.
# @arg $1 Package or script name.
# @arg $@ Arguments passed to package/script.
# shellcheck disable=SC2120 # it's a function
source() {
    __0="${__0:-source}"
    if ! (( $# )); then
        echo "$__0: error: package or script is required" >&2
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
        printf "%s$__0: error: no package/script called '$name'\n" "" >&2

        for failed_path in "${failed_paths[@]}"; do
            printf "%s\tno file '$failed_path'\n" "" >&2
        done

        exit 1
    else
        builtin source "$path" "$@"
    fi
}

# @description Alias of `source`.
# @arg $1 Package or script name.
# @arg $@ Arguments passed to package/script.
# shellcheck disable=SC1090 # it's a function
.() { __0='.' source "$@"; }

export -f source
export -f .
export SOURCE_SEARCHERS
export SOURCE_PATH
